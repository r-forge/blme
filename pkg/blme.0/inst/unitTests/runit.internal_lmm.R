cat("\n\nRUnit test cases for blme.0::bmer_lmmTest function\n\n");

test.blme.lmm.internals <- function()
{
  .Call("bmer_lmmTest");
}
