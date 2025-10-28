# -2D-Convolution-FIR-Filters-Blur-Sharpen-Edges-
Q1. Why is Gaussian preferred over large box LP?
Because Gaussian has smoother frequency response without sharp cutoffs or ringing artifacts. It preserves edges better and reduces aliasing compared to the box filter.

Q2. What does separability do for computational cost?
A separable filter (like Gaussian) can be implemented as two 1D convolutions (horizontal + vertical), reducing computation from 𝑂(𝑁2)O(N2) to 𝑂(2𝑁)O(2N).

Q3. How do boundary modes change corners/edges?

Replicate: repeats edge pixels — avoids dark borders.

Symmetric: mirrors edges — smoothest visual transition.

Circular: wraps around — can create visible seams or artifacts.
