#*- coding:utf-8 -*-
import sys
import os
import md5
import json
def walk(p):
    data=[]
    #  print "base path",p
    p=os.path.abspath(p)
    print p
    for root,dirs,files in os.walk(p):
        path=root.split('/')
        for file in files:
            if not file.startswith("."):
            #  print(len(path) * '---',root,file)
                s=os.path.join(root,file)
                try:

                    f=open(s,"r")
                    str=f.read()
                    m=md5.new()
                    m.update(str)
                    f.close()
                    #  print m.hexdigest()
                    # print s
                    rel_path=s.replace(p,"")
                    # print rel_path
                    data.append({"full_path":s,"rel_path":rel_path,"md5":m.hexdigest()})
                    #  print str
                    #  print s
                except Exception,e:
                    print e
      
    
    return data

if __name__=="__main__":
    p='/Volumes/gameproj/ThreeKingdoms/threekingdoms/res'
    files_md5=walk(p)

    #  创建版本文件
    version_data={}
    version_data['packageUrl']="http://updater-10064935.cos.myqcloud.com/tcg/"
    version_data['remoteVersionUrl']="http://updater-10064935.cos.myqcloud.com/tcg/version.manifest"
    version_data['remoteManifestUrl']='http://updater-10064935.cos.myqcloud.com/tcg/project.manifest'
    version_data['engineVersion']='Quick Cocos2d-x v3.6.2'
    version_data['version']='1.160601.2'

    version_data_str=json.dumps(version_data,indent=4,sort_keys=True)
     # print version_data_str
    f=open("version.manifest","w")
    f.write(version_data_str)
    f.close()
        

    project_data={}
    project_data['packageUrl']="http://updater-10064935.cos.myqcloud.com/tcg/"
    project_data['remoteVersionUrl']="http://updater-10064935.cos.myqcloud.com/tcg/version.manifest"
    project_data['remoteManifestUrl']='http://updater-10064935.cos.myqcloud.com/tcg/project.manifest'
    project_data['engineVersion']='Quick Cocos2d-x v3.6.2'
    
    assets={}
    project_data["assets"]=assets

    for x in files_md5:
        # print x['rel_path']
        assets[x['rel_path']]={"md5":x['md5']}
        pass

    project_data_str=json.dumps(project_data,indent=4,sort_keys=False)
    # print project_data_str
    f=open("project.manifest","w")
    f.write(project_data_str)
    f.close()
