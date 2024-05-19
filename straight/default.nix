{
  straightSource,
  trivialBuild,
}:
trivialBuild rec {
  pname = "straight.el";
  version = "20220901.0";
  ename = pname;
  patches = [./nogit.patch];
  src = straightSource;
}
