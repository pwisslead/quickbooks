'''Wizard for creating odbc settings file'''
import sys

from PySide import QtGui
import pyodbc
import dbf

def get_page_id(wizard, page):
    for page_id in wizard.pageIds():
        if wizard.page(page_id) is page:
            return page_id

class IntroPage(QtGui.QWizardPage):
    def __init__(self):
        QtGui.QWizardPage.__init__(self)
        self.setTitle("External Data Source Setup")

        label = QtGui.QLabel("Select the interface type")
        label.setWordWrap(True)

        self.comboBox = QtGui.QComboBox()
        self.comboBox.addItems(['ODBC', 'FTP'])

        self.comboBox2 = QtGui.QComboBox()
        self.comboBox2.addItems(['Retrieve Data', 'Return Data'])

        self.layout = QtGui.QVBoxLayout()
        self.layout.addWidget(label)
        self.layout.addWidget(self.comboBox)
        self.layout.addWidget(self.comboBox2)
        self.setLayout(self.layout)

    def nextId(self):
        if self.comboBox.currentText() == 'ODBC':
            if self.comboBox2.currentText() == 'Retrieve Data':
                return get_page_id(self.wizard(), self.wizard().odbc_retrieve)
            if self.comboBox2.currentText() == 'Return Data':
                return get_page_id(self.wizard(), self.wizard().odbc_return)
        return get_page_id(self.wizard(), self.wizard().invalid_page)

class SourcePage(QtGui.QWizardPage):
    def __init__(self):
        QtGui.QWizardPage.__init__(self)
        self.setCommitPage(False)
        self.setTitle("Datasource")
        self.setSubTitle("Please select a datasource")

        self.sourceCombo = QtGui.QComboBox()
        sources = [source for source in pyodbc.dataSources().keys()]
        self.sourceCombo.addItems(sources)

        layout = QtGui.QGridLayout()
        layout.addWidget(self.sourceCombo, 0, 0)
        self.setLayout(layout)

    def validatePage(self):
        try:
            self.wizard().cnxn = pyodbc.connect('dsn=' + self.sourceCombo.currentText())
            self.wizard().dsn = self.sourceCombo.currentText()
            return True
        except pyodbc.Error as err:
            QtGui.QMessageBox().critical(self, 'Error', str(err))
            return False

class TablesPage(QtGui.QWizardPage):
    def __init__(self):
        QtGui.QWizardPage.__init__(self)
        self.setCommitPage(False)
        self.setTitle("Select Table")

        self.comboBox = QtGui.QComboBox()

        self.layout = QtGui.QVBoxLayout()
        self.layout.addWidget(self.comboBox)
        self.setLayout(self.layout)

    def selectedTable(self):
        self.wizard().table = self.comboBox.currentText()

    def initializePage(self):
        self.comboBox.clear()
        self.setTitle("Select Table from " + self.wizard().dsn)
        try:
            tables = [table.table_name for table in self.wizard().cnxn.cursor().tables()]
        except AttributeError:
            tables = [table.tablename for table in self.wizard().cnxn.cursor().tables()]
        self.comboBox.addItems(tables)
        self.comboBox.currentIndexChanged.connect(self.selectedTable)
        self.wizard().table = self.comboBox.currentText()

class FieldsPage(QtGui.QWizardPage):
    def __init__(self):
        QtGui.QWizardPage.__init__(self)
        self.setCommitPage(False)
        self.setTitle("Select Fields")

        self.fieldsBox = QtGui.QListWidget()
        self.fieldsBox.itemDoubleClicked.connect(self.addFieldClicked)
        self.fieldsBox.setSortingEnabled(True)
        self.chosenBox = QtGui.QListWidget()
        self.chosenBox.itemDoubleClicked.connect(self.rmFieldClicked)
        self.chosenBox.setSortingEnabled(True)

        self.addBtn = QtGui.QPushButton('Add Field')
        self.addBtn.clicked.connect(self.addField)
        self.rmBtn = QtGui.QPushButton('Remove Field')
        self.rmBtn.clicked.connect(self.rmField)

        self.btnlayout = QtGui.QVBoxLayout()
        self.btnlayout.addWidget(self.addBtn)
        self.btnlayout.addWidget(self.rmBtn)

        self.layout = QtGui.QHBoxLayout()
        self.layout.addWidget(self.fieldsBox)
        self.layout.addLayout(self.btnlayout)
        self.layout.addWidget(self.chosenBox)
        self.setLayout(self.layout)

    def addField(self):
        self.chosenBox.addItem(self.fieldsBox.takeItem(self.fieldsBox.currentRow()))

    def addFieldClicked(self, item):
        self.addField()

    def rmField(self):
        self.fieldsBox.addItem(self.chosenBox.takeItem(self.chosenBox.currentRow()))

    def rmFieldClicked(self, item):
        self.rmField()

    def initializePage(self):
        self.fieldsBox.clear()
        self.chosenBox.clear()
        table = self.wizard().table
        self.setTitle("Select Fields from " + table)
        cur = self.wizard().cnxn.cursor()
        try:
            fields = [field.column_name for field in cur.columns(table=table)]
        except AttributeError:
            fields = [field.columnname for field in cur.columns(table=table)]
        self.fieldsBox.addItems(fields)

    def validatePage(self):
        self.wizard().fields = [self.chosenBox.item(n).text() for n in range(self.chosenBox.count())]
        return True

def matchup(txt):
    layout = QtGui.QHBoxLayout()
    label = QtGui.QLabel(txt)
    layout.box = QtGui.QComboBox()
    layout.addWidget(label)
    layout.addWidget(layout.box)
    return layout

class MatchPage(QtGui.QWizardPage):
    def __init__(self, fields):
        QtGui.QWizardPage.__init__(self)
        self.setCommitPage(False)
        self.setTitle("Match Fields")

        self.layout = QtGui.QVBoxLayout()
        self.matchers = {}
        for field, label in fields:
            self.matchers[field] = matchup(label)
            self.layout.addLayout(self.matchers[field])
        self.setLayout(self.layout)

    def initializePage(self):
        if not 'matchers' in dir(self.wizard()):
            self.wizard().matchers = {}
        for key in self.matchers:
            self.wizard().matchers[key] = self.matchers[key].box
            self.matchers[key].box.clear()
            self.matchers[key].box.addItems([''])
            self.matchers[key].box.addItems(self.wizard().fields)

class ReturnTypePage(QtGui.QWizardPage):
    def __init__(self):
        QtGui.QWizardPage.__init__(self)
        self.setTitle("Select Return Type")
        label = QtGui.QLabel("Select Return Type")

        self.comboBox = QtGui.QComboBox()
        self.comboBox.addItems(['Insert', 'Update'])

        self.layout = QtGui.QVBoxLayout()
        self.layout.addWidget(label)
        self.layout.addWidget(self.comboBox)
        self.setLayout(self.layout)

    def validatePage(self):
        self.wizard().return_type = self.comboBox.currentText()
        return True

def invalidPage():
    page = QtGui.QWizardPage()
    page.setTitle("This function has not been implemented")
    page.isFinalPage = lambda: True
    return page

class SaveODBCPage(QtGui.QWizardPage):
    def __init__(self, setup_type):
        QtGui.QWizardPage.__init__(self)
        self.setCommitPage(False)
        self.setTitle("Save Settings")

    def nextId(self):
        return -1

    def validatePage(self):
        setupstr = ''
        matchers = self.wizard().matchers
        fields = matchers.keys()
        for key in fields:
            setupstr += ';%s C(%d)' % (key, max(len(matchers[key].currentText()), 1))
	return_type = getattr(self.wizard(), 'return_type', ' ')
	if return_type.strip():
            tablename = 'InterfaceReturnSetup'
        else:
            tablename = 'InterfaceSetup'
        setupstr = ('type N(3, 0); dsn C(%d); user C(1); pass C(1); table C(%d); rettype C(%d)' % (len(self.wizard().dsn), len(self.wizard().table), len(return_type))) + setupstr
        table = dbf.Table(tablename, setupstr)
        table.open()
        datum = tuple([1, self.wizard().dsn, '', '', self.wizard().table, return_type] + [matchers[key].currentText() for key in fields])
        table.append(datum)
        table.close()
        return True

def main(args=None):
    '''main'''

    app = QtGui.QApplication(sys.argv)

    wizard = QtGui.QWizard()
    wizard.addPage(IntroPage())

    wizard.odbc_retrieve = SourcePage()
    wizard.addPage(wizard.odbc_retrieve)
    wizard.addPage(TablesPage())
    wizard.addPage(FieldsPage())

    fields = [['IO', 'INTERFACE PROMPT'],
              ['PKG_ID', 'PACKAGE ID'],
              ['INVC_NO', 'INVOICE NUMBER'],
              ['ORD_NO', 'ORDER NUMBER'],
              ['PO_NO', 'PO NUMBER'],
              ['DEPT_NO', 'DEPT NUMBER'],
              ['REF1', 'REFERENCE 1'],
              ['REF2', 'REFERENCE 2'],
              ['REF3', 'REFERENCE 3'],
              ['TRCARCODE', 'CARRIER CODE'],
	      ['SHIPWT', 'SHIP WEIGHT']]
    wizard.addPage(MatchPage(fields))

    fields = [['SHIPCUST', 'SHIP TO CUSTOMER #'],
              ['SHIPCOMP', 'SHIP TO COMPANY'],
              ['SHIPATTN', 'SHIP TO ATTENTION'],
              ['SHIPADDR1', 'SHIP TO ADDRESS 1'],
              ['SHIPADDR2', 'SHIP TO ADDRESS 2'],
              ['SHIPADDR3', 'SHIP TO ADDRESS 3'],
              ['SHIPCITY', 'SHIP TO CITY'],
              ['SHIPSTATE', 'SHIP TO STATE'],
              ['SHIPZIP', 'SHIP TO ZIPCODE'],
              ['TRCTRYCD', 'COUNTRY CODE'],
              ['SHIPPHNO', 'SHIP TO PHONE #'],
              ['SHIPEMAIL', 'SHIP TO EMAIL']]
    wizard.addPage(MatchPage(fields))

    fields = [['BILLMETHOD', 'BILLING METHOD'],
              ['BILLCARACT', 'BILL TO ACCT #'],
              ['BILLNO', 'BILL TO NUMBER'],
              ['BILLCOMP', 'BILL TO COMPANY'],
              ['BILLATTN', 'BILL TO ATTENTION'],
              ['BILLADDR1', 'BILL TO ADDRESS 1'],
              ['BILLADDR2', 'BILL TO ADDRESS 2'],
              ['BILLADDR3', 'BILL TO ADDRESS 3'],
              ['BILLCITY', 'BILL TO CITY'],
              ['BILLSTATE', 'BILL TO STATE'],
              ['BILLZIP', 'BILL TO ZIPCODE'],
              ['BILLCTRY', 'BILL TO COUNTRY'],
              ['BILLCTRYCD', 'BILL TO COUNTRY CODE'],
              ['BILLPHNO', 'BILL TO PHONE #']]
    wizard.addPage(MatchPage(fields))

    fields = [['RETNAME', 'RETURN NAME'],
              ['RETATTN', 'RETURN ATTENTION'],
              ['RETADDR1', 'RETURN ADDRESS 1'],
              ['RETADDR2', 'RETURN ADDRESS 2'],
              ['RETADDR3', 'RETURN ADDRESS 3'],
              ['RETCITY', 'RETURN CITY'],
              ['RETSTATE', 'RETURN STATE'],
              ['RETZIP', 'RETURN ZIPCODE'],
              ['RETPHNO', 'RETURN PHONE #']]
    wizard.addPage(MatchPage(fields))

    fields = [['DIMLENGTH', 'DIMENSIONAL LENGTH'],
              ['DIMWIDTH', 'DIMENSIONAL WIDTH'],
              ['DIMHEIGHT', 'DIMESIONAL HEIGHT'],
              ['RSDNTL', 'RESIDENTIAL'],
              ['SATDELIV', 'SATURDAY DELIVERY'],
              ['SATPICKUP', 'SATURDAY PICKUP'],
              ['CODAMNT', 'COD AMOUNT'],
              ['INSURAMNT', 'INSURANCE AMOUNT']]
    wizard.addPage(MatchPage(fields))

    fields = [['MISC1', 'MISC 1'],
              ['MISC2', 'MISC 2'],
              ['MISC3', 'MISC 3'],
              ['MISC4', 'MISC 4'],
              ['RBRSTMP1', 'RUBBER STAMP 1'],
              ['RBRSTMP2', 'RUBBER STAMP 2'],
              ['RBRSTMP3', 'RUBBER STAMP 3']]
    wizard.addPage(MatchPage(fields))
    wizard.addPage(SaveODBCPage('Retrieve'))

    wizard.odbc_return = ReturnTypePage()
    wizard.addPage(wizard.odbc_return)
    wizard.addPage(SourcePage())
    wizard.addPage(TablesPage())
    wizard.addPage(FieldsPage())
    fields = [
              ['IO', 'INTERFACE PROMPT'],
              ['PACKID', 'PACKAGE ID'],
              ['TRACKNUM', 'TRACKING NUMBER'],
              ['SERVCHRG', 'SERVICE CHARGES'],
              ['DISFRTCHRG', 'DISCOUNT FREIGHT CHARGES'],
              ['DISTOTCHRG', 'DISCOUNT TOTAL CHARGES'],
              ['PUBFRTCHRG', 'PUBLISHED FREIGHT CHARGES'],
              ['PUBTOTCHRG', 'PUBLISHED TOTAL CHARGES'],
              ['BILLWGT', 'BILLABLE WEIGHT'],
              ['SHIPWGT', 'SHIP WEIGHT'],
             ]
    wizard.addPage(MatchPage(fields))
    wizard.addPage(SaveODBCPage('Return'))

    wizard.invalid_page = invalidPage()
    wizard.addPage(wizard.invalid_page)

    wizard.setWindowTitle("Interface Setup Wizard")
    wizard.show()

    sys.exit(wizard.exec_())
    

if __name__ == '__main__':
    main()
