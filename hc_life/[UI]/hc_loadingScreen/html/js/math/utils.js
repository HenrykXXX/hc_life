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