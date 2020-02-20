# Color settings
bkg_clr = {'r': 38, 'g': 38, 'b': 38}
fnt_clr = {'r': 255, 'g': 255, 'b': 255}
nod_clr = {'r': 175, 'g': 175, 'b': 175}
hglt_clr = {'r': 204, 'g': 163, 'b': 0}
alive_clr = {'r': 51, 'g': 102, 'b': 255}

# Text size settings
date_size = 13
name_size = 32

node_length = 10  # number of years a node represents
num_nodes = 10    # number of nodes per line
node_dim = 3      # node dimensions (size)
hglt_dim = 12     # highlighted node dimensions
earliest_year = latest_year = year_spacing = 0

class DomDate:
    def __init__(self, year_v, dom_v):
        self.dom_v = dom_v
        self.year_v = year_v
        if year_v == 0:
            self.year_v = 1
        
    def __str__(self):
        return str(self.year_v) + (' AD' if self.dom_v == 'a' else ' BC')
        
    def __repr__(self):
        return self.__str__()
    
    def __lt__(self, other):
        if self.dom_v == other.dom_v:
            if self.dom_v == 'b':
                return self.year_v > other.year_v
            else:
                return self.year_v < other.year_v
        else:
            return self.dom_v > other.dom_v
        
    def __sub__(self, other):
        if self.dom_v == other.dom_v:
            return abs(self.year_v - other.year_v)
        return self.year_v + other.year_v
    
    def __eq__(self, other):
        return self.dom_v == other.dom_v and self.year_v == other.year_v
    
    def __ne__(self, other):
        return not self.__eq__(other)
    
    def __le__(self, other):
        return self.__lt__(other) or self.__eq__(other)
    
    def addYears(self, num_years):
        if self.dom_v == 'a':
            self.year_v = self.year_v + num_years
        else:
            if self.year_v - num_years < 1:
                self.dom_v = 'a'
                self.year_v = num_years - self.year_v + 1
            else:
                self.year_v = self.year_v - num_years

class Entry:
    def __init__(self, string_entry):
        string_entry = string_entry.split()
        self.birth_date = DomDate(int(string_entry[0]), string_entry[1])
        try:
            self.death_date = DomDate(int(string_entry[2]), string_entry[3])
            self.still_alive = False
            self.full_name = ' '.join(string_entry[4:])
        except:
            self.death_date = DomDate(year(), 'a')
            self.still_alive = True
            self.full_name = ' '.join(string_entry[2:])
            
    def dateString(self):
        if not self.still_alive:
            return str(self.birth_date) + ' - ' + str(self.death_date)
        else:
            return str(self.birth_date) + ' - ?? AD'
        
    def __str__(self):
        return self.full_name + ' => ' + self.dateString()
        
    def __repr__(self):
        return self.__str__()
    
    def __lt__(self, other):
        if self.birth_date == other.birth_date:
            if self.death_date == other.death_date:
                return self.full_name < other.full_name
            return self.death_date < other.death_date
        return self.birth_date < other.birth_date

class NodeGrid:
    def __init__(self, x, y, w, h, num_w, num_h, node_size = 15, node_clr = {'r': 255, 'g': 255, 'b': 255}):
        self.x = x
        self.y = y
        self.w = w
        self.h = h
        self.num_w = num_w
        self.num_h = num_h
        self.node_size = node_size
        self.node_clr = node_clr
        
        self.h_buf = 15
        self.v_buf = 5
        
        self.labels = None
        self.label_size = None
        self.label_clr = None
        
    def setTextBuffers(self, h_buf, v_buf):
        self.h_buf = h_buf
        self.v_buf = v_buf
        
    def setLabelInfo(self, labels, label_size, label_clr):
        self.labels = labels
        self.label_size = label_size
        self.label_clr = label_clr
        
    def drawGrid(self):
        for i in range(self.num_h):
            if self.labels is not None:
                textSize(self.label_size)
                stroke(self.label_clr['r'], self.label_clr['g'], self.label_clr['b'])
                fill(self.label_clr['r'], self.label_clr['g'], self.label_clr['b'])
                textAlign(RIGHT)
                cur_x = self.x - self.h_buf
                cur_y = self.y + i * (self.h / float(self.num_h)) + self.v_buf
                text(self.labels[0][i], cur_x, cur_y)
                textAlign(LEFT)
                cur_x = self.x + self.w - self.h_buf
                text(self.labels[1][i], cur_x, cur_y)
            for j in range(self.num_w):
                cur_x = self.x + j * (self.w / float(self.num_w))
                cur_y = self.y + i * (self.h / float(self.num_h))
                stroke(self.node_clr['r'], self.node_clr['g'], self.node_clr['b'])
                fill(self.node_clr['r'], self.node_clr['g'], self.node_clr['b'])
                rectMode(CENTER)
                rect(cur_x, cur_y, self.node_size, self.node_size)
                
    def drawNode(self, x, y, node_size, node_clr):
        cur_x = self.x + x * (self.w / float(self.num_w))
        cur_y = self.y + y * (self.h / float(self.num_h))
        stroke(node_clr['r'], node_clr['g'], node_clr['b'])
        fill(node_clr['r'], node_clr['g'], node_clr['b'])
        rectMode(CENTER)
        rect(cur_x, cur_y, node_size, node_size)

entries = []
ng = None

def setupYearLines():
    global ng
    ng = NodeGrid(160, 100, 300, 600, num_nodes, (latest_year - earliest_year) / year_spacing, node_dim, nod_clr)
    labels = []
    labels.append([])
    cur_year = DomDate(earliest_year.year_v, earliest_year.dom_v)
    labels[0].append(str(cur_year))
    while cur_year < latest_year:
        cur_year.addYears(year_spacing)
        labels[0].append(str(cur_year))
        
    labels.append([])
    cur_year = DomDate(earliest_year.year_v, earliest_year.dom_v)
    end_year = DomDate(latest_year.year_v, latest_year.dom_v)
    cur_year.addYears(year_spacing - 1)
    end_year.addYears(year_spacing - 1)
    labels[1].append(str(cur_year))
    while cur_year < end_year:
        cur_year.addYears(year_spacing)
        labels[1].append(str(cur_year))
        
    ng.setLabelInfo(labels, date_size, fnt_clr)

def clearScreen():
    stroke(bkg_clr['r'], bkg_clr['g'], bkg_clr['b'])
    fill(bkg_clr['r'], bkg_clr['g'], bkg_clr['b'])
    rectMode(CORNER)
    rect(0, 0, 600, 860)
    ng.drawGrid()

def drawEntry(entry):
    maths = ceil(entry.birth_date.year_v / float(node_length))
    if entry.birth_date.dom_v == 'a':
        maths = floor(entry.birth_date.year_v / float(node_length))
    node_start = DomDate(int(maths) * node_length, entry.birth_date.dom_v)
    maths = ceil(entry.death_date.year_v / float(node_length))
    if entry.death_date.dom_v == 'a':
        maths = floor(entry.death_date.year_v / float(node_length))
    node_end = DomDate(int(maths) * node_length, entry.death_date.dom_v)
    print(entry, node_start, node_end)
    cur_node = DomDate(node_start.year_v, node_start.dom_v)
    
    textSize(name_size)
    stroke(fnt_clr['r'], fnt_clr['g'], fnt_clr['b'])
    fill(fnt_clr['r'], fnt_clr['g'], fnt_clr['b'])
    textAlign(CENTER)
    text(entry.full_name, 300, 780)
    
    textSize(date_size)
    stroke(fnt_clr['r'], fnt_clr['g'], fnt_clr['b'])
    fill(fnt_clr['r'], fnt_clr['g'], fnt_clr['b'])
    textAlign(CENTER)
    text(entry.dateString(), 300, 800)
    
    while cur_node <= node_end:
        maths = ceil(cur_node.year_v / float(year_spacing))
        if cur_node.dom_v == 'a':
            maths = floor(cur_node.year_v / float(year_spacing))
        line_start = DomDate(int(maths) * year_spacing, cur_node.dom_v)
        x = (cur_node - line_start) / node_length
        y = (line_start - earliest_year) / year_spacing
        if entry.still_alive:
            ng.drawNode(x, y, hglt_dim, alive_clr)
        else:
            ng.drawNode(x, y, hglt_dim, hglt_clr)
        cur_node.addYears(node_length)

def setup():
    global entries, node_length, num_nodes, earliest_year, latest_year, year_spacing
    size(600, 860)
    frameRate(.5)
    background(bkg_clr['r'], bkg_clr['g'], bkg_clr['b'])
    str_entries = loadStrings('people.txt')
    for e in str_entries:
        entries.append(Entry(e))
    entries.sort()
    year_spacing = node_length * num_nodes
    earliest_year = DomDate(int(ceil(entries[0].birth_date.year_v / float(year_spacing))) * year_spacing, entries[0].birth_date.dom_v)
    death_year_entr = sorted(entries, key=lambda e: e.death_date.year_v)[-1]
    latest_year = DomDate(int(ceil(death_year_entr.death_date.year_v / float(year_spacing))) * year_spacing, death_year_entr.death_date.dom_v)
    print(entries)
    setupYearLines()
    ng.drawGrid()
        
idx = 0
def draw():
    global idx
    hasFinished = False
    if idx < len(entries) and not hasFinished:
        clearScreen()
        ng.drawGrid()
        drawEntry(entries[idx])
        idx = idx + 1
    elif idx == len(entries):
        hasFinished = True
