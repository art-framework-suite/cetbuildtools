#include <iostream>
#include <assert.h>
#include "ToyCmake/DoMath.h"

int main()
{
  ToyCmake::DoMath mth;

  double x,y;
  x = 4.;
  assert( mth.calculate(x) == 16. );
  
  y = 5.;
  mth.setval(y); 
  assert( mth.calculate(x) == 80. );

  return 0;
}

