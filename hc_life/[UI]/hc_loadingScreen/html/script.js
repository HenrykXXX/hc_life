class Graph {
    constructor(points = [], segments = [])
    {
        this.points = points;
        this.segments = segments;
    }

    addPoint(point)
    {
        this.points.push(point);
    }

    removePoint(point)
    {
        const segs = this.getSegmentsWithPoint(point);
        for (const seg of segs)
        {
            this.removeSegment(seg);
        }
        this.points.splice(this.points.indexOf(point), 1);
    }

    containsPoint(point)
    {
        return (this.points.find((p) => p.equals(point)));
    }

    tryAddPoint(point)
    {
        if (!this.containsPoint(point))
        {
            this.addPoint(point);
            return true;
        }
        return false;
    }

    addSegment(segment)
    {
        this.segments.push(segment);
    }

    removeSegment(segment)
    {
        this.segments.splice(this.segments.indexOf(segment), 1);
    }

    containsSegment(segment)
    {
        return this.segments.find((s) => s.equals(segment));
    }

    tryAddSegment(segment)
    {
        if (!this.containsSegment(segment))
        {
            this.addSegment(segment);
            return true;
        }
        return false;
    }

    getSegmentsWithPoint(point)
    {
        const segs = [];
        for (const seg of this.segments)
        {
            if (seg.includes(point))
            {
                segs.push(seg);
            }
        }
        return segs;
    }

    dispose()
    {
        this.points.length = 0;
        this.segments.length = 0;
    }

    draw(ctx)
    {
        for (const seg of this.segments)
        {
            seg.draw(ctx);
        }

        for (const point of this.points)
        {
            point.draw(ctx);
        }
    }
}

function distance(p1, p2)
{
    return Math.hypot(p1.x - p2.x, p1.y - p2.y);
}

function getNearestPoint(loc, points, threshold = 10)
{
    let minDist = Number.MAX_SAFE_INTEGER;
    let nearest = null;
    for (const p of points)
    {
        const dist = distance(loc, p);
        if ((dist < minDist) && (dist < threshold))
        {
            minDist = dist;
            nearest = p;
        }
    }
    return nearest;
}


class GraphEditor {
    constructor(canvas, graph)
    {
        this.canvas = canvas;
        this.graph = graph;

        this.ctx = this.canvas.getContext("2d");

        this.selected = null;
        this.hovered = null;

        this.#addEventListeners();
    }

    #addEventListeners()
    {
        this.canvas.addEventListener("mousedown", (evt) => {
            const mouse = new Point(evt.offsetX, evt.offsetY);
            if (this.hovered)
            {
                this.selected = this.hovered;
            } else {
                this.graph.tryAddPoint(mouse);
                this.selected = mouse;
            }
            
        });

        this.canvas.addEventListener("mousemove", (evt) => {
            const mouse = new Point(evt.offsetX, evt.offsetY);
            this.hovered = getNearestPoint(mouse, this.graph.points);
        });
    }

    display()
    {
        this.graph.draw(this.ctx);
        
        if (this.selected)
        {
            this.selected.draw(this.ctx , { outline : true });
        }

        if (this.hovered)
        {
            this.hovered.draw(this.ctx , { fill : true });  
        }
    }
}


console.log("script.js running");

const segmentThreshold = 0.05; // 1/10 of screen size
const numPoints = 200;
const maxSpeed = 1;
const gravityStrength = 5;
const gravityThreshold = 10000;

function createSegments() {
  for (let i = 0; i < graph.points.length; i++) {
    for (let j = i + 1; j < graph.points.length; j++) {
      const p1 = graph.points[i];
      const p2 = graph.points[j];
      const dist = distance(p1, p2);
      if (dist < Math.min(myCanvas.width, myCanvas.height) * segmentThreshold) {
        graph.tryAddSegment(new Segment(p1, p2));
      }
    }
  }
}


function createRandomPoint() {
  const vx = Math.random() * 2 * maxSpeed - maxSpeed;
  const vy = Math.random() * 2 * maxSpeed - maxSpeed;

  return new Point(
    Math.random() * myCanvas.width,
    Math.random() * myCanvas.height,
    vx,
    vy
  );
}

function updatePoints() {
  for (let i = graph.points.length - 1; i >= 0; i--) {
    const point1 = graph.points[i];
    point1.update();

    for (let j = 0; j < graph.points.length; j++) {
      if (i !== j) {
        const point2 = graph.points[j];
        const dx = point2.x - point1.x;
        const dy = point2.y - point1.y;
        const distSq = dx * dx + dy * dy;

        if (distSq < gravityThreshold * gravityThreshold) {
          //const dist = Math.sqrt(distSq);
          const force = gravityStrength / distSq;
          const forceX = force * dx / distSq;
          const forceY = force * dy / distSq;
          point1.vx += forceX;
          if (point1.vx > 5) { point1.vx = 2};
          point1.vy += forceY;
          if (point1.vy > 5) { point1.vy = 2};
        }
      }
    }

    if (
      point1.x < 0 ||
      point1.x > myCanvas.width ||
      point1.y < 0 ||
      point1.y > myCanvas.height
    ) {
      graph.removePoint(point1);
      graph.addPoint(createRandomPoint());
    }
  }
}

function init() {
  myCanvas.width = window.innerWidth;
  myCanvas.height = window.innerHeight;

  graph.dispose();

  for (let i = 0; i < numPoints; i++) {
    graph.addPoint(createRandomPoint());
  }
}

function animate() {
  ctx.clearRect(0, 0, myCanvas.width, myCanvas.height);
  updatePoints();
  createSegments();
  graphEditor.display();
  requestAnimationFrame(animate);
}

const ctx = myCanvas.getContext("2d");
const graph = new Graph();
const graphEditor = new GraphEditor(myCanvas, graph);

init();
animate();