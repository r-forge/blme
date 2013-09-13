setClass("bmerNormalDist", contains = "bmerDist",
         slots = c(R.cov.inv = "matrix"));

toString.bmerNormalDist <- function(x, digits = getOption("digits"), ...) {
  cov <- solve(tcrossprod(x@R.cov.inv));
  sds <- sqrt(diag(cov));
  corrs <- diag(1 / sds) %*% cov %*% diag(1 / sds);
  
  sds <- round(sds, digits);
  corrs <- round(corrs[lower.tri(corrs)], digits);
  
  if (nrow(cov) > 2) {
    covString <- paste("sd = c(", sds[1:2], ", ...), corr = c(", corrs[1], " ...)", sep = "");
  } else if (nrow(cov) == 1) {
    covString <- paste("sd = c(", sds[1:2], "), corr = ", corrs[1], sep = "");
  } else {
    covString <- paste("sd = ", sds[1], sep = "");
  }
  
  paste("normal(", covString,
        ", common.scale = ", x@commonScale,
        ")", sep="");
}

setMethod("getDFAdjustment", "bmerNormalDist",
  function(object) {
    if (object@commonScale == TRUE) sum(diag(object@R.cov.inv) != 0) else 0;
  }
);
setMethod("getConstantTerm", "bmerNormalDist",
  function(object) {
    R.cov.inv <- object@R.cov.inv;
    if (any(diag(R.cov.inv) < 0)) return(NA);
    
    nonZeroes <- diag(R.cov.inv) != 0;
    rank <- sum(nonZeroes);
    
    rank * log(2 * pi) - 2.0 * sum(log(diag(R.cov.inv)[nonZeroes]));
  }
);
setMethod("getExponentialSigmaPower", "bmerNormalDist",
  function(object) { if (object@commonScale == TRUE) -2 else 0; }
);
setMethod("getExponentialTerm", "bmerNormalDist",
  function(object, beta) {
    exponential <- crossprod(object@R.cov.inv %*% beta)[1];
    if (object@commonScale == TRUE) c(-2, exponential) else c(0, exponential);
  }
);
