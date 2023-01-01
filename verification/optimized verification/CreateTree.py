from treelib import Tree
from sympy import sympify,preorder_traversal

def creteTreeFromObervation(expr):
    '''
        creteTreeFromObervation: Use a string like 
        "((a&b^c)&r)^(r1&r)" to create 
        a tree like \\
        Xor \\
        ├── And \\
        │   ├── Xor \\
        │   │   ├── And \\
        │   │   │   ├── a \\
        │   │   │   └── b \\ 
        │   │   └── c \\
        │   └── r \\
        └── And \\
            ├── r \\
            └── r1 \\
    '''
    #expr=sympify(x,convert_xor=False)
    whoreTree=Tree()
    rootList=[]
    for argID,arg in enumerate(preorder_traversal(expr)):
        if(argID==0): 
            whoreTree.create_node(tag=str(arg.func).replace(" ",""), identifier=str(argID), data=str(arg).replace(" ","")) 
            rootList.append([str(argID),len(arg.args)]) 
            continue
        if(str(arg.func)=="Xor" or str(arg.func)=="And"): 
            parent=rootList.pop()
            parent[1]-=1
            whoreTree.create_node(tag=str(arg.func).replace(" ",""), identifier=str(argID), data=str(arg).replace(" ",""),parent=parent[0]) 
            if(parent[1]>0): 
                rootList.append(parent)
            rootList.append([str(argID),len(arg.args)])
        elif(str(arg.func)=="Not"): 
            parent=rootList.pop()
            parent[1]-=1
            whoreTree.create_node(tag=str(arg).replace(" ",""), identifier=str(argID), data=str(arg).replace(" ",""),parent=parent[0]) 
            if(parent[1]>0): 
                rootList.append(parent)
            rootList.append(["Not",len(arg.args)])
        else: 
            parent=rootList.pop()
            if(parent[0]=="Not"): 
                continue
            parent[1]-=1
            whoreTree.create_node(tag=str(arg).replace(" ",""), identifier=str(argID), data=str(arg).replace(" ",""),parent=parent[0])
            if(parent[1]>0):
                rootList.append(parent)
    return whoreTree