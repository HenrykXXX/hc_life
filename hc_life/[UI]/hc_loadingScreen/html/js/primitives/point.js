class Point {
    constructor(x, y, vx = 1, vy = 1) {
        this.x = x;
        this.y = y;
        this.vx = vx;
        this.vy = vy;
    }

    equals(point)
    {
        return (this.x == point.x && this.y == point.y);
    }

    draw(ctx, {size = 6, color = "white", fill = false, outline = false} = {})
    {
        const rad = size/2;
        ctx.beginPath();
        ctx.fillStyle = color;
        ctx.arc(this.x, this.y, rad, 0, Math.PI * 2);
        ctx.fill();

        if (outline)
        {
            ctx.beginPath();
            ctx.lineWidth = 2;
            ctx.strokeStyle = "white";
            ctx.arc(this.x, this.y, rad * 0.8, 0, Math.PI * 2);
            ctx.stroke();
        }

        if (fill)
        {
            ctx.beginPath();
            ctx.fillStyle = "white";
            ctx.arc(this.x, this.y, rad * 0.2, 0, Math.PI * 2);
            ctx.fill();
        }
    }

    update() {
        this.x += this.vx;
        this.y += this.vy;
    }
}