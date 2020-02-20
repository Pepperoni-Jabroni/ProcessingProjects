periods = [i*50+50 for i in range(7)]
v_line_locs = [0 for i in range(len(periods))]
h_line_locs = [0 for i in range(len(periods))]
colors = [
          {'r': 255, 'g': 0, 'b': 0},
          {'r': 244, 'g': 152, 'b': 66},
          {'r': 255, 'g': 233, 'b': 0},
          {'r': 0, 'g': 255, 'b': 0},
          {'r': 0, 'g': 250, 'b': 255},
          {'r': 242, 'g': 147, 'b': 209},
          {'r': 221, 'g': 147, 'b': 242}
          ]
h_lcs = []
v_lcs = []
curves = []

class LissajousCircle:
    def __init__(self, speed, x, y, dir, clr={'r': 255, 'g': 255, 'b': 255}, rad=25, mark_rad=7, dotl=True):
        self.speed = 60.0 * speed # 60 fps, sec/rot float -> frames/rot float
        self.x = x
        self.y = y
        self.mark_theta = 0
        self.mark_rad = mark_rad
        self.clr = clr
        self.tick_count =  0
        self.rad = rad
        self.dotl = dotl
        self.dir = dir
        self.drawCircle()
        
    def tick(self):
        self.mark_theta = self.mark_theta + (360.0 / self.speed)
        self.drawCircle()
        
    def drawCircle(self):
        noFill()
        stroke(self.clr['r'], self.clr['g'], self.clr['b'])
        strokeWeight(3)
        ellipse(self.x, self.y, self.rad * 2, self.rad * 2)
        mark_x = self.rad * cos(self.mark_theta) + self.x
        mark_y = self.rad * sin(self.mark_theta) + self.y
        if self.dir == 'r' and self.dotl:
            self.drawDotted(mark_x, mark_y, mark_x, 900, 500, 10)
        if self.dir == 'd' and self.dotl:
            self.drawDotted(mark_x, mark_y, 900, mark_y, 500, 10)
        stroke(255)
        strokeWeight(1)
        fill(255)
        ellipse(mark_x, mark_y, self.mark_rad * 2, self.mark_rad * 2)
        
    def drawDotted(self, x1, y1, x2, y2, num_lines, spacing, clr={'r': 175, 'g': 175, 'b': 175}):
        line_dist = dist(x1, y1, x2, y2)
        space_dist = spacing
        seg_lgth = (line_dist - space_dist) / num_lines
        theta = atan2(abs(y1 - y2),abs(x1 - x2))
        stroke(clr['r'], clr['g'], clr['b'])
        strokeWeight(1)
    
        cur_x = x1
        cur_y = y1
        for i in range(num_lines):
            seg_x2 = seg_lgth * cos(theta) + cur_x
            seg_y2 = seg_lgth * sin(theta) + cur_y
            line(cur_x, cur_y, seg_x2, seg_y2)
            cur_x = seg_x2 + space_dist * cos(theta) 
            cur_y = seg_y2 + space_dist * sin(theta) 
            
class LissajousCurve:
    def __init__(self, clr={'r': 255, 'g': 255, 'b': 255}):
        self.clr = clr
        self.points = []
        self.max_points = 50
        
    def addPoint(self, x, y):
        if len(self.points) == 0:
            self.points.append((x, y))
            return
        (x2, y2) = self.points[-1]
        if sqrt((x2 - x)**2 + (y2 - y)**2) > 15:  
            self.points.append((x, y))
        #if len(self.points) > self.max_points:
        #    self.points = [self.points[i] for i in range(0, len(self.points) / 2)]
        
    def drawCurve(self):
        if len(self.points) == 0:
            return
        #stroke(self.clr['r'], self.clr['g'], self.clr['b'])
        #fill(self.clr['r'], self.clr['g'], self.clr['b'])
        #ellipse(self.points[-1][0], self.points[-1][1], 2, 2)
        #for (x, y) in self.points:
        #    stroke(self.clr['r'], self.clr['g'], self.clr['b'])
        #    fill(self.clr['r'], self.clr['g'], self.clr['b'])
        #    ellipse(x, y, 2, 2)
        noFill()
        strokeWeight(2)
        stroke(self.clr['r'], self.clr['g'], self.clr['b'])
        beginShape()
        for (x, y) in self.points:
            curveVertex(x, y)
        endShape()
            
def drawDotMatrix():
    global v_line_locs, h_line_locs
    stroke(255)
    fill(255)
    for i in v_line_locs:
        for j in h_line_locs:
            ellipse(i, j, 7, 7)


def setup():
    global h_lcs, periods, v_lcs, v_line_locs, h_line_locs, curves
    size(825, 825)
    background(51)
    push_val = 75
    circ_const = 50
    
    idx = 0
    for i in periods:
        h_lcs.append(LissajousCircle(i, push_val + (idx*100+100), circ_const, 'r', clr=colors[(idx*100+100)/100-1], rad=40, mark_rad=6, dotl=False))
        v_lcs.append(LissajousCircle(i, circ_const, push_val + (idx*100+100), 'd', clr=colors[(idx*100+100)/100-1], rad=40, mark_rad=6, dotl=False))
        idx = idx + 1
        
    for i in range(len(periods)):
        for j in range(len(periods)):
            r = (h_lcs[i].clr['r'] + v_lcs[j].clr['r']) / 2
            g = (h_lcs[i].clr['g'] + v_lcs[j].clr['g']) / 2
            b = (h_lcs[i].clr['b'] + v_lcs[j].clr['b']) / 2
            curves.append(LissajousCurve(clr={'r':r, 'g':g, 'b':b}))
    
def draw():
    global h_lcs, v_lcs, v_line_locs, h_line_locs, curves
    background(51)
    [lc.tick() for lc in h_lcs]
    [lc.tick() for lc in v_lcs]
    for i in range(len(periods)):
        v_line_locs[i] = h_lcs[i].rad * cos(h_lcs[i].mark_theta) + h_lcs[i].x
        h_line_locs[i] = v_lcs[i].rad * sin(v_lcs[i].mark_theta) + v_lcs[i].y
    # if random(2) == 0:
    for i in range(len(periods)):
        for j in range(len(periods)):
            curves[(i*len(periods)+j)].addPoint(v_line_locs[i], h_line_locs[j])
    [c.drawCurve() for c in curves]
    drawDotMatrix()
