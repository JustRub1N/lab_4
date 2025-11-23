MATCH (n) DETACH DELETE n;

UNWIND [
  "USER","HUNGRY","OPEN APP","INTERFACE","SCREEN","BUTTON",
  "INPUT","SCROLL","VIEW","SEARCH","TYPE","CLICK","ORDER","RETURN"
] AS name
MERGE (:Node {name:name});

MATCH (a:Node {name:"USER"}),(b:Node {name:"HUNGRY"}) MERGE (a)-[:HAS_STATE]->(b);
MATCH (a:Node {name:"HUNGRY"}),(b:Node {name:"OPEN APP"}) MERGE (a)-[:IS_CAUSE_OF]->(b);
MATCH (a:Node {name:"OPEN APP"}),(b:Node {name:"INTERFACE"}) MERGE (a)-[:PRECEDES]->(b);

FOREACH (x IN ["TYPE","SEARCH","SCREEN","SCROLL","VIEW","INPUT"] |
  MERGE (:Node {name:x})
)
WITH 1 AS dummy
MATCH (i:Node {name:"INTERFACE"})
MATCH (t:Node {name:"TYPE"}),(s:Node {name:"SEARCH"}),(sc:Node {name:"SCREEN"}),(sr:Node {name:"SCROLL"}),(v:Node {name:"VIEW"}),(inp:Node {name:"INPUT"})
MERGE (i)-[:PRECEDES]->(t)
MERGE (i)-[:PRECEDES]->(s)
MERGE (i)-[:PRECEDES]->(sc)
MERGE (i)-[:PRECEDES]->(sr)
MERGE (i)-[:PRECEDES]->(v)
MERGE (i)-[:PRECEDES]->(inp);

MATCH (a:Node {name:"SEARCH"}),(b:Node {name:"TYPE"}) MERGE (a)-[:INTERACTS_WITH]->(b) MERGE (b)-[:INTERACTS_WITH]->(a);
MATCH (a:Node {name:"SCROLL"}),(b:Node {name:"VIEW"}) MERGE (a)-[:TRANSITIONS_TO]->(b) MERGE (b)-[:TRANSITIONS_TO]->(a);
MATCH (a:Node {name:"SEARCH"}),(b:Node {name:"INPUT"}) MERGE (a)-[:INVOLVES]->(b) MERGE (b)-[:INVOLVES]->(a);
MATCH (a:Node {name:"TYPE"}),(b:Node {name:"INPUT"}) MERGE (a)-[:INVOLVES]->(b) MERGE (b)-[:INVOLVES]->(a);

MATCH (a:Node {name:"SCROLL"}),(b:Node {name:"CLICK"}) MERGE (a)-[:TRANSITIONS_TO]->(b);
MATCH (a:Node {name:"VIEW"}),(b:Node {name:"CLICK"}) MERGE (a)-[:TRANSITIONS_TO]->(b);
MATCH (a:Node {name:"TYPE"}),(b:Node {name:"CLICK"}) MERGE (a)-[:TRANSITIONS_TO]->(b);

MATCH (a:Node {name:"CLICK"}),(b:Node {name:"ORDER"}) MERGE (a)-[:PRECEDES]->(b);
MATCH (a:Node {name:"CLICK"}),(b:Node {name:"RETURN"}) MERGE (a)-[:PRECEDES]->(b);
MATCH (a:Node {name:"RETURN"}),(b:Node {name:"SCROLL"}) MERGE (a)-[:BACK_TO]->(b);

MATCH (a:Node {name:"SCROLL"}),(b:Node {name:"SCREEN"}) MERGE (a)-[:TRANSITIONS_TO]->(b);
MATCH (a:Node {name:"SCROLL"}),(b:Node {name:"BUTTON"}) MERGE (a)-[:INVOLVES]->(b);
MATCH (a:Node {name:"INTERFACE"}),(b:Node {name:"BUTTON"}) MERGE (a)-[:INVOLVES]->(b);