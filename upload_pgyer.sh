# pgyer
uKey=
apiKey=
pgyerUrl=https://www.pgyer.com/apiv1/app/upload

# path
projectName=fuji
projectPath=$(pwd)
androidApkPath=${projectPath}/build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk
iosIpaPath=${projectPath}/build/ios/ipa/${projectName}.ipa

# 飞书机器人发送消息地址
fsBotUrl=""

# ex
cd ${projectPath}

# android
androidBuildResult=$(flutter build apk --split-per-abi --no-shrink)
androidSuccess=0
if [[ "$androidBuildResult" == *"Built build/app"* ]]; then
  androidSuccess=1
  echo '========build android succeed========'
else
  echo '========build android failed========'
fi

# ios
iosBuildResult=$(flutter build ipa --export-method ad-hoc)
iosSuccess=0
if [[ "$iosBuildResult" == *"Built IPA to"* ]]; then
  iosSuccess=1
  echo '========build ios succeed========'
else
  echo '========build ios failed========'
fi

# 只有都打包成功，才能上传和通知
if [[ $androidSuccess == 0 || $iosSuccess == 0 ]]; then
  exit
fi

# upload
uploadResult=$(
  curl \
    -F "file=@/${androidApkPath}" \
    -F "uKey=${uKey}" \
    -F "_api_key=${apiKey}" \
    ${pgyerUrl}
)

uploadResult=$(
  curl \
    -F "file=@/${iosIpaPath}" \
    -F "uKey=${uKey}" \
    -F "_api_key=${apiKey}" \
    ${pgyerUrl}
)

# 通知飞书机器人群组
curl -X POST -H "Content-Type: application/json" -d '{
                                                         "msg_type": "post",
                                                         "content": {
                                                          "post": {
                                                           "zh_cn": {
                                                            "title": "APP打包通知",
                                                            "content": [
                                                             [{
                                                               "tag": "text",
                                                               "un_escape": true,
                                                               "text": "line 1:",
                                                               "lines": 1
                                                              },
                                                              {
                                                               "tag": "a",
                                                               "text": "Android下载地址",
                                                               "href": "https://www.pgyer.com/"
                                                              }
                                                             ],
                                                             [{
                                                               "tag": "text",
                                                               "un_escape": true,
                                                               "text": "line 2:",
                                                               "lines": 1
                                                              },
                                                              {
                                                               "tag": "a",
                                                               "text": "IOS下载地址",
                                                               "href": "https://www.pgyer.com/"
                                                              }
                                                             ]
                                                            ]
                                                           }
                                                          }
                                                         }
                                                       }' $fsBotUrl
