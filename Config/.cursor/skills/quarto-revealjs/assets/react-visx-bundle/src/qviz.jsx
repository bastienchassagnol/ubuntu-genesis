// visx scatter + least-squares line; React owns the SVG, d3/visx do the maths.
import React from "react";
import { createRoot } from "react-dom/client";
import { scaleLinear } from "@visx/scale";
import { AxisBottom, AxisLeft } from "@visx/axis";
import { Group } from "@visx/group";
import { Circle, Line } from "@visx/shape";

function fit(points) {
  const n = points.length;
  const mx = points.reduce((s, p) => s + p.x, 0) / n;
  const my = points.reduce((s, p) => s + p.y, 0) / n;
  let sxy = 0, sxx = 0, syy = 0;
  for (const p of points) {
    sxy += (p.x - mx) * (p.y - my);
    sxx += (p.x - mx) ** 2;
    syy += (p.y - my) ** 2;
  }
  const b = sxy / sxx;
  return { a: my - b * mx, b, r2: (sxy * sxy) / (sxx * syy) };
}

function Scatter({ points, width = 640, height = 400 }) {
  const m = { top: 20, right: 20, bottom: 40, left: 50 };
  const x = scaleLinear({ domain: [0, 10], range: [m.left, width - m.right] });
  const y = scaleLinear({ domain: [-5, 15], range: [height - m.bottom, m.top] });
  const { a, b, r2 } = fit(points);
  return (
    <svg width={width} height={height}>
      <Group>
        {points.map((p, i) => (
          <Circle key={i} cx={x(p.x)} cy={y(p.y)} r={4} fill="#1d4e89" fillOpacity={0.6} />
        ))}
        <Line from={{ x: x(0), y: y(a) }} to={{ x: x(10), y: y(a + b * 10) }}
              stroke="#c45c26" strokeWidth={2} />
        <text x={m.left + 8} y={m.top + 12} fontSize={14} fill="#1c2b24">
          R² = {r2.toFixed(2)}
        </text>
      </Group>
      <AxisBottom top={height - m.bottom} scale={x} />
      <AxisLeft left={m.left} scale={y} />
    </svg>
  );
}

// Called from OJS: mount once, then render() on every input change.
export function mount(el) {
  const root = createRoot(el);
  return { render: (props) => root.render(<Scatter {...props} />), unmount: () => root.unmount() };
}
