#!/usr/bin/env sh

# 确保脚本抛出遇到的错误
set -e

initDist() {
  echo $1 >base.js
  npm run build
  cd docs/.vuepress/dist
}

# 打包，进入到dist目录，设置git域名
initDist "module.exports = '/'"
echo 'testaa.xiaolongsu.cn' >CNAME
# echo 'google.com, pub-7828333725993554, DIRECT, f08c47fec0942fa0' > ads.txt # 谷歌广告相关文件

# deploy to github
if [ -z "$GITHUB_TOKEN" ]; then
  msg='deploy'
  githubUrl=git@github.com:suxiaolong/test.git
else
  msg='来自github actions的自动部署'
  githubUrl=https://suxiaolong:${GITHUB_TOKEN}@github.com/suxiaolong/test.git
  git config --global user.name "suxiaolong"
  git config --global user.email "1349906113@qq.com"
fi

# 在dist里面初始化git仓库 提交代码到远程仓库
initGit() {
  git init
  git add -A
  git commit -m "${msg}"
}
initGit
git push -f $githubUrl master:gh-pages # 推送到github

# 回退跟目录删除dist
cd - # 退回开始的目录
rm -rf docs/.vuepress/dist

# 每次都是把全新的dist目录 init一下，提交到远程仓库

# deploy to coding
initDist "module.exports = '/'"
echo 'coding-doc.xiaolongsu.cn' > CNAME  # 自定义域名
# echo 'google.com, pub-7828333725993554, DIRECT, f08c47fec0942fa0' > ads.txt # 谷歌广告相关文件

if [ -z "$CODING_TOKEN" ]; then  # -z 字符串 长度为0则为true
 codingUrl=git@e.coding.net:serverless-1349906113/bb/a01.git
else
 codingUrl=https://FhThEBDkcW:${CODING_TOKEN}@e.coding.net/serverless-1349906113/bb/a01.git
fi

initGit
git push -f $codingUrl master # 推送到coding

cd -
rm -rf docs/.vuepress/dist
