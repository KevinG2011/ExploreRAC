//
//  mstore.c
//  IAPTest
//
//  Created by lijia on 2018/6/28.
//  Copyright © 2018年 Colin Eberhardt. All rights reserved.
//

#include <stdio.h>

long mult2(long, long);

void multstore(long x, long y, long *dest) {
  long t = mult2(x, y);
  *dest = t;
}
