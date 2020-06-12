//
//  ViewController.m
//  ThreadDemo
//
//  Created by moliangyu on 2020/5/25.
//  Copyright © 2020 LTWM. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
}

- (void)testAction
{
    //Jenkins打包脚本
//# 工程名
//APP_NAME="LTWMYingJi"
//# 证书
//CODE_SIGN_DISTRIBUTION="证书名称"
//# info.plist路径
//#project_infoplist_path="./${APP_NAME}/Info.plist"
//project_infoplist_path="项目Info.plist的路径"
//
//#取版本号
//bundleShortVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleShortVersionString" "${project_infoplist_path}")
//
//#取build值
//bundleVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleVersion" "${project_infoplist_path}")
//
//DATE="$(date +%Y%m%d)"
//
//# /Users/电脑名称/archive/LTWMYingJi_V$(MARKETING_VERSION)_20200611.ipa
//IPANAME="${APP_NAME}_V${bundleShortVersion}_${DATE}.ipa"
//
//#要上传的ipa文件路径，这里我将ipa包放在用户目录下的archive文件夹中
//IPA_PATH="/Users/电脑名称/Library/Developer/Xcode/Archives/${IPANAME}"
//echo ${IPA_PATH}
//echo "${IPA_PATH}">> text.txt
//#获取权限
//security unlock-keychain -p "123456" $HOME/Library/Keychains/login.keychain
//# //下面2行是没有Cocopods的用法
//# echo "=================clean================="
//# xcodebuild -target "${APP_NAME}"  -configuration 'Release' clean
//# echo "+++++++++++++++++build+++++++++++++++++"
//# xcodebuild -target "${APP_NAME}" -sdk iphoneos -configuration 'Release' CODE_SIGN_IDENTITY="${CODE_SIGN_DISTRIBUTION}" SYMROOT='$(PWD)'
//
//#//下面2行是集成有Cocopods的用法
//echo "=================clean================="
//xcodebuild -workspace "workspace路径" -scheme "${APP_NAME}"  -configuration 'Debug' clean
//
//echo "+++++++++++++++++build+++++++++++++++++"
//xcodebuild -workspace "workspace路径" -scheme "${APP_NAME}" -sdk iphoneos -configuration 'Debug' CODE_SIGN_IDENTITY="${CODE_SIGN_DISTRIBUTION}" SYMROOT='$(PWD)'
//
//#//打包输出ipa
//xcrun -sdk iphoneos PackageApplication "./Debug-iphoneos/${APP_NAME}.app" -o ${IPA_PATH}
//
//#上传到蒲公英
//uKey=""
//#蒲公英上的API Key
//apiKey=""
//#蒲公英版本更新描述，这里取git最后一条提交记录作为描述
//MSG=`git log -1 --pretty=%B`
//#要上传的ipa文件路径
//echo $IPA_PATH
//
//#执行上传至蒲公英的命令
//echo "++++++++++++++upload+++++++++++++"
//curl -F "file=@${IPA_PATH}" -F "uKey=${uKey}" -F "_api_key=${apiKey}" -F "buildUpdateDescription=${MSG}" https://www.pgyer.com/apiv2/app/upload
}

@end
