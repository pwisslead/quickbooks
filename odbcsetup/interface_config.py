'''Wizard for creating odbc settings file'''
import sys

from PySide import QtGui
import pyodbc
import dbf

class IntroPage(QtGui.QWizardPage):
    def __init__(self):
        QtGui.QWizardPage.__init__(self)
        self.setTitle("ODBC Setup")

        label = QtGui.QLabel("Select the interface type")
        label.setWordWrap(True)

        self.comboBox = QtGui.QComboBox()
        self.comboBox.addItems(['ODBC', 'FTP', 'Test'])

        self.layout = QtGui.QVBoxLayout()
        self.layout.addWidget(label)
        self.layout.addWidget(self.comboBox)
        self.setLayout(self.layout)

    def nextId(self):
        if self.comboBox.currentText() == 'ODBC':
            return 1
        return 5

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

def invalidPage():
    page = QtGui.QWizardPage()
    page.setTitle("This function has not been implemented")
    page.isFinalPage = lambda: True
    return page

class LastPage(QtGui.QWizardPage):
    def __init__(self):
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
        setupstr = ('type N(3, 0); dsn C(%d); user C(1); pass C(1); table C(%d)' % (len(self.wizard().dsn), len(self.wizard().table))) + setupstr
        print(setupstr)
        table = dbf.Table('InterfaceSetup', setupstr)
        table.open()
        datum = tuple([1, self.wizard().dsn, '', '', self.wizard().table] + [matchers[key].currentText() for key in fields])
        table.append(datum)
        table.close()
        return True

def main(args=None):
    '''main'''

    app = QtGui.QApplication(sys.argv)

    wizard = QtGui.QWizard()
    wizard.addPage(IntroPage())
    wizard.addPage(SourcePage())
    wizard.addPage(TablesPage())
    wizard.addPage(FieldsPage())

    fields = [['IO', 'INTERFACE_PROMPT'],
              ['PKG_ID', 'PACKAGE_ID'],
              ['INVC_NO', 'INVOICE_NO'],
              ['ORD_NO', 'ORDER_NO'],
              ['PO_NO', 'PO_NO'],
              ['DEPT_NO', 'DEPT_NO'],
              ['REF1', 'REF1'],
              ['REF2', 'REF2'],
              ['REF3', 'REF3'],
              ['TRCARCODE', 'TRANSLATED_CARRIER_CODE'],
              ['TRCTRYCD', 'TRANSLATED_COUNTRY_CODE']]
    wizard.addPage(MatchPage(fields))

    fields = [['SHIPWT', 'SHIP_WEIGHT'],
              ['SHIPCUST', 'SHIPTO_CUSTOMER_NO'],
              ['SHIPCOMP', 'SHIPTO_COMPANY'],
              ['SHIPATTN', 'SHIPTO_ATTN'],
              ['SHIPADDR1', 'SHIPTO_ADDR1'],
              ['SHIPADDR2', 'SHIPTO_ADDR2'],
              ['SHIPADDR3', 'SHIPTO_ADDR3'],
              ['SHIPCITY', 'SHIPTO_CITY'],
              ['SHIPSTATE', 'SHIPTO_STATE'],
              ['SHIPZIP', 'SHIPTO_ZIP'],
              ['SHIPCTRY', 'SHIPTO_COUNTRY'],
              ['SHIPCTRYCD', 'SHIPTO_COUNTRY_CODE'],
              ['SHIPPHNO', 'SHIPTO_PHONE_NO'],
              ['SHIPFAXNO', 'SHIPTO_FAX_NO'],
              ['SHIPEMAIL', 'SHIPTO_EMAIL']]
    wizard.addPage(MatchPage(fields))

    fields = [['BILLMETHOD', 'BILLING_METHOD'],
              ['BILLCARACT', 'BILLTO_CARRIER_ACCT_NO'],
              ['BILLCOMP', 'BILLTO_COMPANY'],
              ['BILLATTN', 'BILLTO_ATTN'],
              ['BILLADDR1', 'BILLTO_ADDR1'],
              ['BILLADDR2', 'BILLTO_ADDR2'],
              ['BILLADDR', 'BILLTO_ADDR'],
              ['BILLCITY', 'BILLTO_CITY'],
              ['BILLSTATE', 'BILLTO_STATE'],
              ['BILLZIP', 'BILLTO_ZIP'],
              ['BILLCTRY', 'BILLTO_COUNTRY'],
              ['BILLCTRYCD', 'BILLTO_COUNTRY_CODE'],
              ['BILLPHNO', 'BILLTO_PHONE_NO'],
              ['BILLFAXNO', 'BILLTO_FAX_NO'],
              ['BILLNO', 'BILLTO_NO']]
    wizard.addPage(MatchPage(fields))

    fields = [['RETNAME', 'RETURNLABEL_NAME'],
              ['RETATTN', 'RETURNLABEL_ATTN'],
              ['RETADDR1', 'RETURNLABEL_ADDR1'],
              ['RETCITY', 'RETURNLABEL_CITY'],
              ['RETSTATE', 'RETURNLABEL_STATE'],
              ['RETZIP', 'RETURNLABEL_ZIP'],
              ['RETCTRY', 'RETURNLABEL_COUNTRY'],
              ['RETCTRYCD', 'RETURNLABEL_COUNTRY_CODE'],
              ['RETPHNO', 'RETURNLABEL_PHONE_NO'],
              ['RETFAXNO', 'RETURNLABEL_FAX_NO'],
              ['RETADDR2', 'RETURNLABEL_ADDR2'],
              ['RETADDR3', 'RETURNLABEL_ADDR3']]
    wizard.addPage(MatchPage(fields))

    fields = [['COD', 'COD'],
              ['ADDTOCOD', 'ADDTO_COD'],
              ['CLCTCOD', 'COLLECT_COD'],
              ['INSUR', 'INSURANCE'],
              ['SATDELIV', 'SAT_DELIVERY'],
              ['SATPICKUP', 'SAT_PICKUP'],
              ['DIMNSNL', 'DIMENSIONAL'],
              ['RSDNTL', 'RESIDENTIAL'],
              ['CODAMNT', 'COD_AMOUNT'],
              ['CODCHRG', 'COD_CHARGE'],
              ['INSURAMNT', 'INSURANCE_AMOUNT'],
              ['INSURCHRG', 'INSURANCE_CHARGE']]
    wizard.addPage(MatchPage(fields))

    fields = [['CALLTGCHRG', 'CALL_TAG_CHARGE'],
              ['DIMLENGTH', 'DIMENSIONAL_LENGTH'],
              ['DIMWIDTH', 'DIMENSIONAL_WIDTH'],
              ['DIMHEIGHT', 'DIMESIONAL_HEIGHT'],
              ['DIMWEIGHT', 'DIMENSIONAL_WEIGHT'],
              ['MISC1', 'MISC1'],
              ['MISC2', 'MISC2'],
              ['MISC3', 'MISC3'],
              ['MISC4', 'MISC4'],
              ['RBRSTMP1', 'RUBBER_STAMP1'],
              ['RBRSTMP2', 'RUBBER_STAMP2'],
              ['RBRSTMP3', 'RUBBER_STAMP3']]
    wizard.addPage(MatchPage(fields))

    wizard.addPage(LastPage())
    wizard.addPage(invalidPage())

    wizard.setWindowTitle("Interface Setup Wizard")
    wizard.show()

    sys.exit(wizard.exec_())
    

if __name__ == '__main__':
    main()
