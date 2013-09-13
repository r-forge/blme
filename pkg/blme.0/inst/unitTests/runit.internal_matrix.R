cat("\n\nRUnit test cases for blme.0:::bmer_matrixTest function\n\n");

test.blme.matrix.internals <- function()
{
  .Call("bmer_matrixTest");
}
