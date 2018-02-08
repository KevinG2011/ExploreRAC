//
//  ViewController.m
//  IAPTest
//
//  Created by lijia on 2018/2/8.
//  Copyright © 2018年 Colin Eberhardt. All rights reserved.
//

#import "ViewController.h"
#import <StoreKit/StoreKit.h>
#include "Receipt.h"

@interface ViewController () <SKProductsRequestDelegate,SKPaymentTransactionObserver> {
    NSArray *_productIdentifiers;
    SKProductsRequest *_productsRequest;
    NSArray *_orderProducts;
    NSString *_receipt;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _receipt = receiptStr;
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    _productIdentifiers = @[@"clubfee1",@"bean6"];
    
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:_productIdentifiers]];
    _productsRequest.delegate = self;
    [_productsRequest start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    if (response.products.count > 0)
    {
        _orderProducts = [response.products sortedArrayUsingComparator:^NSComparisonResult(SKProduct *obj1, SKProduct *obj2) {
            return [obj1.price compare:obj2.price];
        }];
        for (SKProduct *aProduct in _orderProducts)
        {
            NSLog(@"productIdentifier: %@",aProduct.productIdentifier);
            NSLog(@"localizedTitle: %@",aProduct.localizedTitle);
        }
    }
}

#pragma mark - <SKPaymentTransactionObserver>
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:{
                NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
                NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];
                _receipt = [receipt base64EncodedStringWithOptions:0];
                
                NSLog(@"receipt :%@", _receipt);
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            }
            case SKPaymentTransactionStateFailed:
            case SKPaymentTransactionStateRestored:
            case SKPaymentTransactionStateDeferred:
            default:
                break;
        }
    }
}

- (void)purchaseWithSKProduct:(SKProduct*)aProduct
{
    if ([SKPaymentQueue canMakePayments] && aProduct != nil)
    {
        SKPayment *aPayment = [SKPayment paymentWithProduct:aProduct];
        [[SKPaymentQueue defaultQueue] addPayment:aPayment];
    }
}


- (IBAction)purchaseClicked:(id)sender {
    if (_orderProducts) {
        [self purchaseWithSKProduct:_orderProducts.firstObject];
    }
}

- (void)validateReceipt {
    if (_receipt) {
        NSError *error;
        NSString *sharedSecret = @"1bc5df4b75b448ac880cc97d5190f075";
        NSDictionary *requestContents = @{ @"receipt-data": _receipt,
                                           @"password":sharedSecret,
                                           };
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents
                                                              options:0
                                                                error:&error];
        
        if (!requestData) { /* ... Handle error ... */ }
        
        // Create a POST request with the receipt data.
        NSURL *storeURL = [NSURL URLWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
        NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:storeURL];
        [storeRequest setHTTPMethod:@"POST"];
        [storeRequest setHTTPBody:requestData];
        
        /*
         21000    App Store不能读取你提供的JSON对象
         21002    receipt-data域的数据有问题
         21003    receipt无法通过验证
         21004    提供的shared secret不匹配你账号中的shared secret
         21005    receipt服务器当前不可用
         21006    receipt合法，但是订阅已过期。服务器接收到这个状态码时，receipt数据仍然会解码并一起发送
         21007    receipt是Sandbox receipt，但却发送至生产系统的验证服务
         21008    receipt是生产receipt，但却发送至Sandbox环境的验证服务
         */
        NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:storeRequest
                                                                 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                NSLog(@"error :%@",[error localizedDescription]);
            } else {
                NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                if (jsonResponse) {
                    NSLog(@"response :%@",jsonResponse);
                }
            }
        }];
        [task resume];
    }
}

- (IBAction)validateClicked:(id)sender {
    [self validateReceipt];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
