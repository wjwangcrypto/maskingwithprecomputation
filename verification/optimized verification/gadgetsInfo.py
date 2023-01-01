from sympy import sympify ,symbols
from itertools import combinations,islice
from math import comb
# Local files
import Paras
Token={ "proc":"",
        "secrets":"",
        "inputs":"",
        "outputs":"",
        "randoms":"",
        "check":"",
        "mode":""
        }
# 表达式
exprs=dict()
# 中间值
Observations=[]
def analProc(checks):
    Token["check"]=checks
    try:
        with open("gadgets/"+Token["check"][0], "r" ) as script: 
            for item in script.readlines():
                temp= item.strip(" ").replace("\t","").replace("\n","").split(" ")
                ignore=False
                if(temp[0][0]=="~"):
                    ignore=True
                    temp[0]=temp[0][1:]
                if(temp[0]=="proc"):
                    Token[temp[0]] =temp[-1] 
                    continue
                elif(temp[0]=="inputs"): 
                    inputs = temp[-1].split(",")
                    tempLs=[]
                    secrets=[]
                    for ip in inputs:
                        secrets.append(ip[0])
                        ip=symbols(ip)
                        for i in ip:
                            tempLs.append(str(i))
                        if(not ignore):
                            Observations.extend(tempLs)
                    Token[temp[0]]=tempLs
                    Token["secrets"]=secrets
                    continue
                elif(temp[0]=="outputs"):
                    outputs = temp[-1].split(",")
                    tempLs=[]
                    for op in outputs:
                        op=symbols(op)
                        for o in op:
                            tempLs.append(str(o))
                    Token[temp[0]]=tempLs
                    continue
                elif(temp[0]=="randoms"):
                    randoms = temp[-1].split(",")
                    tempLs=[]
                    for rand in randoms:
                        rand=symbols(rand)
                        for r in rand:
                            tempLs.append(str(r))
                        if(not ignore):
                            Observations.extend(tempLs)
                    Token[temp[0]]=tempLs
                    del tempLs
                    del randoms
                    continue
                elif(temp[0]=="mode"):
                    Token[temp[0]]=temp[1]
                    continue
                else: 
                    temp = temp[0].replace(" ","").split("=") 
                    if(ignore): 
                        continue
                    if(Token["mode"]=="user"):
                        if(";" in temp[-1]): 
                            exprs[temp[0]]=temp[-1]
                            continue
                    if("," in temp[-1]):
                        newtemp=temp[-1].split(",")
                        for t in newtemp:
                            args=sympify(t,convert_xor=False).args
                            if(len(args)==0):
                                if(exprs.get(temp[0])!=None):
                                    if(exprs.get(temp[-1])!=None):
                                        exprs[temp[0]]=exprs[temp[0]]+";"+exprs[temp[-1]].split(";")[-1]
                                    elif(exprs.get(temp[0])==None):
                                        exprs[temp[0]]=exprs[temp[0]]+";"+temp[-1]
                                elif(exprs.get(temp[0])==None):
                                    if(exprs.get(temp[-1])!=None):
                                        exprs[temp[0]]=exprs[temp[-1]].split(";")[-1]
                                    elif(exprs.get(temp[0])==None):
                                        exprs[temp[0]]=temp[-1]
                                continue
                            for a in args:
                                value=exprs.get(str(a))
                                if(value!=None):
                                    value=value.split(";")[-1]
                                    temp[-1]=temp[-1].replace(str(a),"("+value+")")
                            if(exprs.get(temp[0])!=None):
                                exprs[temp[0]]=exprs[temp[0]]+";"+temp[-1]
                            elif(exprs.get(temp[0])==None):
                                exprs[temp[0]]=temp[-1]
                        continue
                    args=sympify(temp[-1],convert_xor=False).args
                    if(len(args)==0):
                        if(exprs.get(temp[0])!=None):
                            if(exprs.get(temp[-1])!=None):
                                exprs[temp[0]]=exprs[temp[0]]+";"+exprs[temp[-1]].split(";")[-1]
                            elif(exprs.get(temp[0])==None):
                                exprs[temp[0]]=exprs[temp[0]]+";"+temp[-1]
                        elif(exprs.get(temp[0])==None):
                            if(exprs.get(temp[-1])!=None):
                                exprs[temp[0]]=exprs[temp[-1]].split(";")[-1]
                            elif(exprs.get(temp[0])==None):
                                exprs[temp[0]]=temp[-1]
                        continue
                    for a in args:
                        value=exprs.get(str(a))
                        if(value!=None):
                            value=value.split(";")[-1]
                            temp[-1]=temp[-1].replace(str(a),"("+value+")")
                    if(exprs.get(temp[0])!=None):
                        exprs[temp[0]]=exprs[temp[0]]+";"+temp[-1]
                    elif(exprs.get(temp[0])==None):
                        exprs[temp[0]]=temp[-1]
        extrObs()
        return True
    except Exception as exc:
        print("Read File Error: ",exc)
        return False
def extrObs(): # 提取程序的中间值
    if(Token["check"][2]=="true"):
        print("Gadget basic info: ",Token)
        print("Gadget all leakages: ",exprs)
    if(Token["mode"]=="user"):
        tempOb=[]
        for key in exprs:
            tempOb.append(exprs[key].split(";"))
        
        k=len(tempOb)+1
        temp=[0,0,0,0,0,0,0,0,0,0]
        allPossible=[]
        for a in range(k):
            temp[0]=a
            for b in range(k-a):
                temp[1]=b
                for c in range(k-a-b):
                    temp[2]=c
                    for d in range(k-a-b-c):
                        temp[3]=d
                        for e in range(k-a-b-c-d):
                            temp[4]=e
                            for f in range(k-a-b-c-d-e):
                                temp[5]=f
                                for g in range(k-a-b-c-d-e-f):
                                    temp[6]=g
                                    for h in range(k-a-b-c-d-e-f-g):
                                        temp[7]=h
                                        for i in range(k-a-b-c-d-e-f-g-h):
                                            temp[8]=i
                                            for j in range(k-a-b-c-d-e-f-g-i):
                                                temp[9]=j
                                                if(sum(temp)==k-1):
                                                    allPossible.append(temp.copy())
        
        finalOb=[]
        for item in allPossible:
            Ob=[]
            for iID,i in enumerate(item):
                if(i>0):
                    for j in range(i):
                        Ob.append(tempOb[j][iID])
            finalOb.append(",".join(Ob))
        checkObservations=finalOb
        Paras.P.append(Paras.AllParas(Token["proc"],exprs,Token["secrets"],Token["inputs"],Token["outputs"],Token["randoms"],[],checkObservations,Observations,{},Token["check"]))
        return True
    # no user mode.
    for value in exprs:
        Observations.extend(exprs[value].split(";"))
    
    OutputsObser={}
    for op in Token["outputs"]:
        if(str(op) in exprs):
            OutputsObser[str(op)]=exprs[str(op)]
    checkObservations=Observations
    if(int(Token["check"][-1])==1):
        checkObservations=Observations.copy()
    elif(int(Token["check"][-1])>1):
        if(len(Observations)<int(Token["check"][-1])):
            checkObservations=list(combinations(Observations, len(Observations)))
        # max value=30507895
        tempList=[]
        returnList=[]
        max=30507895
        end=comb(len(Observations),int(Token["check"][-1]))
        for i in range(0,end,max):
            tempList.extend(list(islice(combinations(Observations, int(Token["check"][-1])),i,i+max)))
            for item in tempList:
                returnList.append((','.join(item)))
        checkObservations=returnList
        # no max value.
        tempList=list(combinations(Observations, int(Token["check"][-1])))
        returnList=[]
        if(tempList):
            for item in tempList:
                returnList.append((','.join(item)))
        checkObservations=returnList
    else:
        checkObservations=Observations.copy()
    Paras.P.append(Paras.AllParas(Token["proc"],exprs,Token["secrets"],Token["inputs"],Token["outputs"],Token["randoms"],[],checkObservations,Observations,OutputsObser,Token["check"]))
    return True