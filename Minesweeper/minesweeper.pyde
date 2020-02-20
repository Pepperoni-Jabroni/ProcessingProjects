class GameMode:
    def __init__(self, height, width, mines):
        self.height = height
        self.width = width
        self.mines = mines
        
# Create default game-mode global settings
GAME_MODES = [GameMode(9, 9, 10), GameMode(16, 16, 40), GameMode(16, 30, 99)]

CELL_STATES = set(['HIDDEN', 'REVEALED', 'CLICKED', 'FLAG'])

CELL_TYPES = set(['EMPTY', 'BOMB', 'NUMBER'])

CELL_NUMBER_INDEX = [color(0, 0, 250), color(22, 117, 52), color(250, 0, 0), color(17, 21, 130), color(130, 17, 34), color(27, 126, 196), color(0), color(122)]

class Cell():
    def __init__(self, x, y, grid):
        self.cell_state = 'HIDDEN'
        self.cell_type = 'EMPTY'
        self.numeric_value = None
        self.x = x
        self.y = y
        self.grid = grid
        
    def click_cell_initial(self):
        self.cell_state = 'CLICKED'
        
    def click_cell_final(self):
        self.cell_state = 'REVEALED'
        
    def flag_cell(self):
        if self.cell_state == 'HIDDEN':
            self.cell_state = 'FLAG'
        elif self.cell_state == 'FLAG':
            self.cell_state = 'HIDDEN'
        
    def render(self):
        global CELL_NUMBER_INDEX
        stroke(0)
        strokeWeight(3)
        if self.cell_state == 'HIDDEN':
            if self.grid.game_over and self.cell_type == 'BOMB':
                fill(0)
            else:
                fill(150)
        elif self.cell_state == 'REVEALED':
            if self.cell_type in ['EMPTY', 'NUMBER']:
                fill(250)
            elif self.cell_type == 'BOMB':
                fill(color(250, 0, 0))
        elif self.cell_state == 'FLAG':
            if self.grid.game_over and self.cell_type == 'BOMB':
                fill(0)
            else:
                fill(222, 171, 18)
        rect(self.x * self.grid.cell_size + self.grid.x_offset, self.y * self.grid.cell_size + self.grid.y_offset, self.grid.cell_size, self.grid.cell_size)
        if self.cell_type == 'NUMBER' and self.cell_state == 'REVEALED':
            number = self.numeric_value
            if number and number <= len(CELL_NUMBER_INDEX):
                fill(CELL_NUMBER_INDEX[number - 1])
                textSize(15)
                text(str(number), (self.x + 0.5) * self.grid.cell_size + self.grid.x_offset, (self.y + 0.75) * self.grid.cell_size + self.grid.y_offset)
            
class Grid():
    def __init__(self, game_mode, x_offset = 0, y_offset = 0):
        self.cell_size = 20.0
        self.game_mode = game_mode
        self.game_over = False
        self.cells = [[Cell(j, i, self) for i in range(game_mode.height)] for j in range(game_mode.width)]
        self.x_offset = x_offset
        self.y_offset = y_offset
                
    def number_for(self, x, y):
        total = 0
        for i in range(x - 1, x + 2):
            for j in range(y - 1, y + 2):
                if i >= 0 and j >= 0 and i < self.game_mode.width and j < self.game_mode.height and self.cells[i][j].cell_type == 'BOMB':
                    total = total + 1
        return total
    
    def click(self, screen_x, screen_y):
        if self.game_over:
            return
        screen_x = screen_x - self.x_offset
        screen_y = screen_y - self.y_offset
        x = int(screen_x / self.cell_size)
        y = int(screen_y / self.cell_size)
        if x >= self.game_mode.width or y >= self.game_mode.height or x < 0 or y < 0:
            return
        print('Clicked ' + str(x) + ' ' + str(y))
        if self.is_first_click():
            while True:
                self.grid_initialization(x, y)
                if self.cells[x][y].cell_type == 'EMPTY':
                    break
        self.cells[x][y].click_cell_final()
        if self.cells[x][y].cell_type == 'BOMB':
            self.game_over = True
            print('You lost!')
            return
        if self.cells[x][y].cell_type == 'EMPTY':
            self.propagate_click(x, y)
        self.check_for_win()
    
    def flag(self, screen_x, screen_y):
        if self.game_over:
            return
        screen_x = screen_x - self.x_offset
        screen_y = screen_y - self.y_offset
        x = int(screen_x / self.cell_size)
        y = int(screen_y / self.cell_size)
        self.cells[x][y].flag_cell()
        print('Flagged ' + str(x) + ' ' + str(y))
        self.check_for_win()
        
    def check_for_win(self):
        try:
            for i in range(self.game_mode.width):
                for j in range(self.game_mode.height):
                    if self.cells[i][j].cell_state == 'FLAG':
                        assert self.cells[i][j].cell_type == 'BOMB'
                    if self.cells[i][j].cell_state == 'REVEALED':
                        assert self.cells[i][j].cell_type in ['EMPTY', 'NUMBER']
                    assert self.cells[i][j].cell_state != 'HIDDEN'
            print('You won!')
            self.game_over = True
        except:
            pass
            
    def propagate_click(self, click_x, click_y):
        for i in range(click_x - 1, click_x + 2):
            for j in range(click_y - 1, click_y + 2):
                if i >= 0 and i < self.game_mode.width and j >= 0 and j < self.game_mode.height:
                    if not (i == click_x and j == click_y):
                        if self.cells[i][j].cell_state == 'HIDDEN' and self.cells[i][j].cell_type in ['EMPTY', 'NUMBER']:
                            self.cells[i][j].click_cell_final()
                            if self.cells[i][j].cell_type == 'EMPTY':
                                self.propagate_click(i, j)
            
    def is_first_click(self):
        all_hidden = True
        for i in range(self.game_mode.width):
            for j in range(self.game_mode.height):
                if self.cells[i][j].cell_state != 'HIDDEN':
                    all_hidden = False
        return all_hidden
    
    def grid_initialization(self, initial_x, initial_y):
        for i in range(self.game_mode.width):
            for j in range(self.game_mode.height):
                    self.cells[i][j].cell_state = 'HIDDEN'
                    self.cells[i][j].cell_type = 'EMPTY'
                    self.cells[i][j].numeric_value = None
                
        for i in range(self.game_mode.mines):
            while True:
                rand_x, rand_y = int(random(self.game_mode.width)), int(random(self.game_mode.height))
                if self.cells[rand_x][rand_y].cell_type != 'BOMB' and not (rand_x == initial_x and rand_y == initial_y):
                    self.cells[rand_x][rand_y].cell_type = 'BOMB'
                    # print('Bomb at ' + str(rand_x) + ' ' + str(rand_y))
                    break
                
        for i in range(self.game_mode.width):
            for j in range(self.game_mode.height):
                temp_val = self.number_for(i, j)
                if temp_val > 0 and self.cells[i][j].cell_type != 'BOMB':
                    self.cells[i][j].numeric_value = temp_val
                    self.cells[i][j].cell_type = 'NUMBER'
                    # print('Cell (' + str(i) + ', ' + str(j) + ') has a value of: ' + str(temp_val))

    def render(self):
        for i in range(self.game_mode.width):
            for j in range(self.game_mode.height):
                self.cells[i][j].render()
    
GRID = None            
def setup():
    global GRID, GAME_MODES
    size(960, 540)
    GRID = Grid(GAME_MODES[2], 30, 45)
    
def draw():
    global GRID
    GRID.render()
    
def mousePressed():
    global GRID
    
def mouseReleased():
    global GRID
    if mouseButton == LEFT:
        GRID.click(mouseX, mouseY)
    else:
        if not GRID.is_first_click():
            GRID.flag(mouseX, mouseY)
        
def keyPressed():
    global GRID
    if key == 'r':
        GRID = Grid(GAME_MODES[2], 30, 45)
        print('New game!')
        
