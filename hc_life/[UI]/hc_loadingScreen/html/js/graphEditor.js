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