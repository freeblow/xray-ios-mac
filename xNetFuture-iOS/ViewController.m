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
            self.startConnectButton.layer.backgroundColor = [UIColor systemRedColor].CGColor;
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
            self.startConnectButton.layer.backgroundColor = [UIColor colorWithRed:2/255.0 green:187/255.0 blue:0/255.0 alpha:1.0].CGColor;
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
}

@end
