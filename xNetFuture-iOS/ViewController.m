//
//  ViewController.m
//  xNetFuture-iOS
//
//  Created by 杨雨东 on 2023/8/17.
//

#import "ViewController.h"
#import "YDVPNManager.h"
#import <NetworkExtension/NetworkExtension.h>

@interface ViewController ()<UITextFieldDelegate>
{
    NETunnelProviderManager *_providerManager;
}
@property (weak, nonatomic) IBOutlet UITextField *protocolTextField;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;

@property (weak, nonatomic) IBOutlet UIButton *startConnectButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __weak ViewController *weakSelf = self;
    [YDVPNManager.sharedManager fetchVPNManager:^(NETunnelProviderManager * _Nullable manager) {
        __strong ViewController *strongSelf = weakSelf;
        if (strongSelf) {
            strongSelf->_providerManager = manager;
        }

        if (manager) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionStatusChanged:) name:NEVPNStatusDidChangeNotification object:manager.connection];
        }
    }];
    self.protocolTextField.delegate = self;
    
//    TODO: This is protocol address
    self.protocolTextField.text = @"";
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
}

-(void)connectionStatusChanged:(NSNotification *)notification {
    NEVPNConnection *connection = notification.object;
    switch (connection.status) {
        case NEVPNStatusInvalid:
            self.statusLab.textColor = [UIColor systemRedColor];
            self.statusLab.text = @"Invalid";
            break;
            
        case NEVPNStatusConnected:{
            self.statusLab.textColor = [UIColor systemGreenColor];
            self.statusLab.text = @"Connected";
            
            [self.startConnectButton setTitle:@"Disconnect" forState:UIControlStateNormal];
            [self.startConnectButton setTitleColor:UIColor.redColor forState:UIControlStateNormal];
        }
            break;
            
        case NEVPNStatusConnecting: {
            self.statusLab.textColor = [UIColor systemOrangeColor];
            self.statusLab.text = @"Connecting";
        }
            break;
            
        case NEVPNStatusDisconnected:{
            self.statusLab.textColor = [UIColor systemRedColor];
            self.statusLab.text = @"Disconnected";
            [self.startConnectButton setTitle:@"Connect" forState:UIControlStateNormal];
            [self.startConnectButton setTitleColor:UIColor.systemGreenColor forState:UIControlStateNormal];
        }
            break;
            
        case NEVPNStatusReasserting:{
            self.statusLab.textColor = [UIColor systemRedColor];
            self.statusLab.text = @"Reasserting";
        }
            break;
        case NEVPNStatusDisconnecting: {
            self.statusLab.text = @"Disconnecting";
            self.statusLab.textColor = [UIColor systemRedColor];
        }
            break;
            
        default:
            break;
    }
}

- (IBAction)startConnectButtonClick:(id)sender {
    if (!_providerManager) {
        return;
    }
    NETunnelProviderSession *session = (NETunnelProviderSession *)_providerManager.connection;
    NSString *title = [self.startConnectButton titleForState:UIControlStateNormal];
    if ([title isEqualToString:NSLocalizedString(@"Connect", nil)]) {
        NSString *uri = self.protocolTextField.text;
        NSError *error;
        
        BOOL isGlobalMode = YES;
        
        NSDictionary *providerConfiguration = @{@"type":@(0), @"uri":uri, @"global":@(isGlobalMode)};
        NETunnelProviderProtocol *protocolConfiguration = (NETunnelProviderProtocol *)_providerManager.protocolConfiguration;
        NSMutableDictionary *copy = protocolConfiguration.providerConfiguration.mutableCopy;
        copy[@"configuration"] = providerConfiguration;
        protocolConfiguration.providerConfiguration = copy;
        [_providerManager saveToPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"saveToPreferencesWithCompletionHandler:%@", error);
            }
        }];
        [session startVPNTunnelWithOptions:@{@"uri":uri, @"global":@(isGlobalMode)} andReturnError:&error];
        if (error) {
            NSLog(@"%@", error);
        }
    }
    else {
        [session stopVPNTunnel];
    }
}

- (IBAction)echoButton:(id)sender {
        NETunnelProviderSession *connection = (NETunnelProviderSession *)_providerManager.connection;
        NSDictionary *echo = @{@"type":@1};
        [connection sendProviderMessage:[NSJSONSerialization dataWithJSONObject:echo options:(NSJSONWritingPrettyPrinted) error:nil] returnError:nil responseHandler:^(NSData * _Nullable responseData) {
    
            NSString *x = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", x);
    
        }];
}

@end
