{pkgs ? import <nixpkgs> {}}:
with builtins; let
  concatMap = builtins.concatMap or (f: xs: concatLists (map f xs));
  flattenPkgs = s: let
    f = p:
      if shouldRecurseForDerivations p
      then flattenPkgs p
      else if isDerivation p
      then [p]
      else [];
  in
    concatMap f (attrValues s);

  outputsOf = p: map (o: p.${o}) p.outputs;

  ageAttrs = pkgs.callPackage ./default.nix {inherit pkgs;};

  agePkgs =
    flattenPkgs
    (listToAttrs
      (map (n: nameValuePair n ageAttrs.${n})
        (attrNames ageAttrs)));
in {
  buildOutputs = concatMap outputsOf agePkgs;
  cacheOutputs = concatMap outputsOf agePkgs;
}
