
class AllParas():
    def __init__(self,name,expressions,secrets,secretsInputs,secretsOutputs,secretsRandoms,shareRandoms,observationsCheck,observations,observationsOutput,checkOptions):
        self.name=name
        self.expressions=expressions

        self.secrets=secrets
        self.secretsInputs=secretsInputs
        self.secretsOutputs=secretsOutputs
        self.secretsRandoms=secretsRandoms
        self.shareRandoms=shareRandoms

        # Check using.
        self.observationsCheck=observationsCheck

        # Store using.
        self.observations=observations 
        self.observationsOutput=observationsOutput 

        # Check using.
        self.checkOptions=checkOptions
        self.R=[]
        self.B=[]
        self.O=""
        self.Oin=[]
        self.Oout=[]
P=[]
'''P.append(AllParas( 
            name="",
            expressions=[],
            share=0,
            secrets=[],
            secretsInputs=[],
            secretsOutputs=[],
            secretsRandoms=[],
            
            observationsCheck=[],

            procDictExpressions={},
            observations=[],

            securityNotion="",
            securityOrder=0,
            checkMode=-1, # 0 for none; 1 for glitch; 2 for transition; 3 for glitch and transition.
            R=set(),
            B=[],
            O=""
            ))
print(type(P[0].R))'''