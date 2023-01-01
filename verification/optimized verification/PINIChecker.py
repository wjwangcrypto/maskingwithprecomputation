# TPL
from random import sample
from sympy import sympify,symbols,preorder_traversal
from sympy.logic.boolalg import to_anf
from timeit import default_timer
from argparse import ArgumentParser

# Local file.
import gadgetsInfo
import CreateTree
import Paras
def firstIf(oList):
    for oID, o in enumerate(oList):
        if("^" not in o and "&" not in o):
            continue
        elif("^" not in o and "&" in o):
            continue
        DoFirstSub=[False,[],""] 
        tempoLS=o.replace("(","").replace(")","").replace("^",",").replace("&",",").replace(" ","").split(",")
        for r in Paras.P[0].secretsRandoms:
            if(tempoLS.count(r)==1): 
                DoFirstSub[0]=True
                DoFirstSub[1].append(r) 
                DoFirstSub[2]=""
        for newoID, newo in enumerate(oList): 
            if(newoID==oID):
                continue
            tempoLS=newo.replace("(","").replace(")","").replace("^",",").replace("&",",").replace(" ","").split(",")
            for r in DoFirstSub[1][::-1]: 
                if(r in tempoLS): 
                    DoFirstSub[1].pop()
        if(DoFirstSub[1]==[]): 
            DoFirstSub[0]=False
        if(DoFirstSub[0]==True): 
            DoFirstSub[0]=False
            expr=sympify(o,convert_xor=False)
            strExpr=str(expr)
            rParent=""
            if("^" not in strExpr and "&" not in strExpr): 
                oList[oID]=strExpr
                continue
            elif("^" not in strExpr and "&" in strExpr):
                oList[oID]=strExpr
                continue
            elif("^" in strExpr and "&" not in strExpr): 
                tempoLS=strExpr.replace("(","").replace(")","").replace("^",",").replace("&",",").replace(" ","").split(",")
                for r in DoFirstSub[1][::-1]:
                    if(r in tempoLS):
                        oList[oID]=r
                        break
                continue
            elif("^" in strExpr and "&" in strExpr):
                oTree=CreateTree.creteTreeFromObervation(expr)
                for r in DoFirstSub[1][::-1]:
                    for node in oTree.expand_tree(mode=CreateTree.Tree.DEPTH): 
                        if(oTree[node].data==r):
                            rParent=oTree.parent(node)
                            if(rParent.tag=="Xor"):
                                DoFirstSub[0]=True
                                DoFirstSub[1]=r
                                PofParent=oTree.parent(rParent.identifier)
                                if(PofParent==None): 
                                    DoFirstSub[2]=rParent.data
                                else:
                                    DoFirstSub[2]=PofParent.data
                            else:break
                    else:break
                    continue
        if(DoFirstSub[0]==True):
            symbolo=sympify(DoFirstSub[2],convert_xor=False)
            symbolR=sympify(DoFirstSub[1],convert_xor=False)
            symbolER=sympify(rParent.data,convert_xor=False)
            symboloAfter=to_anf(symbolo.subs(symbolR,symbolER))
            oList[oID]=str(expr.subs(symbolo,symboloAfter)).replace(" ","")
            Paras.P[0].O=",".join(oList)
            Paras.P[0].B.append([symbolR,symbolER])
            return True

def secondIf(oList):
    maxLevel=[0,0,""] 
    exprLs=[] 
    oTreeLs=[] 
    for oID, o in enumerate(oList): 
        expr=sympify(o,convert_xor=False)
        exprLs.append(expr)
        oTree=CreateTree.creteTreeFromObervation(expr) 
        oTreeLs.append(oTree) 
        level=oTree.depth()
        if(level>=maxLevel[1]):
            maxLevel=[oID,level,oTree]
    if(maxLevel[1]<=0): 
        return False
    DoSecondSub=[False,[]] 
    for node in maxLevel[2].expand_tree(mode=CreateTree.Tree.WIDTH): 
        rnode=maxLevel[2][node].data
        if(rnode in Paras.P[0].secretsRandoms):
            rParent=maxLevel[2].parent(node)
            if(rParent.tag=="Xor"):
                DoSecondSub[1].append(rnode+","+rParent.data)
    for r in DoSecondSub[1][::-1]: 
        r=r.split(",")
        if(r[0] not in Paras.P[0].R): 
            DoSecondSub=[True,r]
            break
    if(DoSecondSub[0]): 
        symbolR=sympify(DoSecondSub[1][0],convert_xor=False)
        symbolER=sympify(DoSecondSub[1][1],convert_xor=False)
        for oID, o in enumerate(oList): 
            if("^" not in o and "&" not in o): 
                if(DoSecondSub[1][0]==o): 
                    oList[oID]=str(symbolER)
                continue
            tempoLS=o.replace("(","").replace(")","").replace("^",",").replace("&",",").replace(" ","").split(",")
            if(DoSecondSub[1][0] not in tempoLS):
                continue
            if("^" in o and "&" not in o):
                symbolPofParent=sympify(o,convert_xor=False)
                symbolo=to_anf(symbolPofParent.subs(symbolR,symbolER))
                oList[oID]=str(symbolo).replace(" ","")
                continue
            strExpr=str(exprLs[oID])
            if("^" not in strExpr and "&" not in strExpr):
                if(DoSecondSub[1][0]==strExpr): 
                    oList[oID]=str(symbolER)
                continue
            elif("^" in strExpr and "&" not in strExpr): 
                symbolPofParent=sympify(strExpr,convert_xor=False)
                symbolo=to_anf(symbolPofParent.subs(symbolR,symbolER))
                oList[oID]=str(symbolo).replace(" ","")
                continue
            for node in oTreeLs[oID].expand_tree(mode=CreateTree.Tree.WIDTH): 
                if(oTreeLs[oID][node].data==DoSecondSub[1][0]):
                    rParent=oTreeLs[oID].parent(node)
                    PofParent=oTreeLs[oID].parent(rParent.identifier)
                    if(PofParent==None): 
                        symbolPofParent=sympify(rParent.data,convert_xor=False)
                    else:
                        symbolPofParent=sympify(PofParent.data,convert_xor=False)
                    symbolo=to_anf(symbolPofParent.subs(symbolR,symbolER)) # r <- e+r
                    #exprLs[oID]=sympify(str(exprLs[oID].subs(symbolPofParent,symbolo)).replace(" ",""),convert_xor=False)
                    exprLs[oID]=exprLs[oID].subs(symbolPofParent,symbolo)
            oList[oID]=str(exprLs[oID]).replace(" ","")
        Paras.P[0].O=",".join(oList)
        Paras.P[0].R.append(DoSecondSub[1][0])
        Paras.P[0].B.append([symbolR,symbolER])
        return True

def transformO(): 
    if("^" not in Paras.P[0].O and "&" not in Paras.P[0].O): 
        return False
    elif("^" not in Paras.P[0].O and "&" in Paras.P[0].O):
        return False
    oList=Paras.P[0].O.split(",")
    
    firstif=firstIf(oList)
    if(firstif):
        return True
       
    secondif=secondIf(oList)
    if(secondif):
        return True
    if(not secondif and not secondif): 
        for oID, o in enumerate(oList):
            oList[oID]=str(to_anf(sympify(o,convert_xor=False)))
        if(Paras.P[0].O==",".join(oList)): 
            return False
        Paras.P[0].O=",".join(oList)
        return None 

def testPINI():
    I=set()
    tempoLS=Paras.P[0].O.replace("(","").replace(")","").replace("^",",").replace("&",",").replace(" ","").split(",")
    for item in Paras.P[0].secretsInputs:
        if(item in tempoLS):
            I.add(int(item[1:]))
    I=I.difference(Paras.P[0].observationsOutput["indices"])
    if(Paras.P[0].checkOptions[2]=="true"):
        if(len(I)>int(Paras.P[0].checkOptions[-1])):
            print("Not PINI. wating transformation, O = %s".rjust(50,"-") %(Paras.P[0].O))
            return False
        return True
    else:
        if(len(I)>int(Paras.P[0].checkOptions[-1])):
            return False
        return True

def checkOneO(): 
    Paras.P[0].R=[] 
    if(Paras.P[0].checkOptions[1]=="pini"):
        Tout()
    while(True):
        if(Paras.P[0].checkOptions[1]=="pini"):
            if(testPINI()):
                return True
        if(transformO()==False):
            return False

def OptSamplingRule(X):
    for xID, x in enumerate(X):
        xList=x.split(",")
        for oID, o in enumerate(xList):
            if(o in Paras.P[0].observationsOutput.values()): 
                continue
            DoSub=[False,""] 
            for r in Paras.P[0].secretsRandoms:
                if(o.count(r)==1): 
                    symbolo=sympify(o,convert_xor=False)
                    for arg in preorder_traversal(symbolo):
                        if(str(arg)==r and str(arg.func)=="Xor"): 
                            DoSub=[True,r]
                            break
                    else: 
                        continue
                    break
            for newoID, newo in enumerate(xList): 
                if(newoID==oID):
                    continue
                if(newo.count(DoSub[1])>0): 
                    DoSub[0]=False
            for newxID, newx in enumerate(X): 
                if(newxID==xID):
                    continue
                if(newx.count(DoSub[1])>0): 
                    DoSub[0]=False
            if(DoSub[0]): 
                o=o.replace()
                symbolo=sympify(o,convert_xor=False)
                symbolR=symbols(DoSub[1])
                oTree=CreateTree.creteTreeFromObervation(o)
                rParent=""
                for node in oTree.expand_tree(mode=CreateTree.Tree.DEPTH): 
                    if(oTree[node].data==DoSub[1]):
                        rParent=oTree.parent(node)
                if(rParent!=""):
                    symbolo=sympify(str(symbolo.subs(symbolR,"("+rParent.data+")")),convert_xor=False) # r <- e+r
    return(X)

def Tout():
    if(Paras.P[0].checkOptions[1]=="pini"):
        t2=0
        O=Paras.P[0].O.split(",")
        tempSet=set()
        for oO in Paras.P[0].observationsOutput:
            if(O.count(Paras.P[0].observationsOutput[oO])>0):
                t2+=1
                tempSet.add(int(oO[1:]))
            if(t2==int(Paras.P[0].checkOptions[-1])):
                break
        Paras.P[0].Oin=int(Paras.P[0].checkOptions[-1])-t2
        Paras.P[0].observationsOutput.update({"indices":tempSet})

def choose():
    Paras.P[0].O=sample(Paras.P[0].observationsCheck,1)[0]
    Paras.P[0].observationsCheck.remove(Paras.P[0].O)

def Replay(O):
    if("^" not in O and "&" not in O):
        return(testPINI())
    tempoLS=Paras.P[0].O.replace("(","").replace(")","").replace("^",",").replace("&",",").replace(" ","").split(",")
    need=False
    for item in Paras.P[0].B:
        if(item in tempoLS):
            need=True
            break
    if(not need):
        return(testPINI())
    for item in Paras.P[0].B:
        oList=O.split(",")
        symbolR=item[0]
        symbolER=item[1]
        for oID, o in enumerate(oList):
            if("^" not in O and "&" not in O):
                continue
            symbolo=to_anf(sympify(o,convert_xor=False).subs(symbolR,symbolER)) # r <- e+r
            oList[oID]=str(symbolo)
        O=",".join(oList)
    Paras.P[0].O=O
    if(Paras.P[0].checkOptions[1]=="pini"):
        return(testPINI())
    Paras.P[0].B=[]
                   
def extend():
    if(Paras.P[0].checkOptions[2]=="true"):
        if(Paras.P[0].B==[]):
            return None
        for oID,o in enumerate(Paras.P[0].observationsCheck):
            print("extend: O = %s" %(o))
            if(Replay(o)):
                Paras.P[0].observationsCheck.pop(oID)
        print("X\X0:".rjust(50,"-"),Paras.P[0].observationsCheck)
    else:
        if(Paras.P[0].B==[]):
            return None
        tempLs=[]
        for o in Paras.P[0].observationsCheck:
            if(not Replay(o)):
                tempLs.append(o)
        Paras.P[0].observationsCheck=tempLs

def checkAllO():
    while(Paras.P[0].observationsCheck):
        # OptSamplingRule(Paras.P[0].observationsCheck)
        choose()
        if(Paras.P[0].checkOptions[2]=="true"):
            print("choose: O = %s" %(Paras.P[0].O))
        if(checkOneO()==False): 
            return False
        #extend()
    return True

# Check.
def parseArgs():
    parser = ArgumentParser(description="Args.")
    parser.add_argument("-a","--address",help = "Address.")
    parser.add_argument("-n","--notions",help = "Notions.")
    parser.add_argument("-o","--order",help = "Order.",type=int)
    parser.add_argument("-d","--detail",help = "Detail.")                   
    args = parser.parse_args()                                              
    return args
def maskingChecker():
    args=parseArgs()
    info=gadgetsInfo.analProc([args.address,args.notions,args.detail,args.order])
    if(not info):
        return False
    print("Check list %s...".rjust(200,"-") %(Paras.P[0].checkOptions))
    print("%d tuples needed to be checked...".rjust(200,"-") %len(Paras.P[0].observationsCheck))
    sTime=default_timer()
    if(checkAllO()):
        print("Gadget is Secure.".rjust(250,"-"))
    else:print("Gadget is not Secure.".rjust(250,"-"))
    eTime=default_timer()
    print("Total time: ".rjust(250,"-"),eTime-sTime)
if __name__=="__main__":
    maskingChecker()
