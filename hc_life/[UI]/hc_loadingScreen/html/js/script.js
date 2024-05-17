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