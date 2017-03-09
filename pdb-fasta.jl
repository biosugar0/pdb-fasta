#!/usr/bin/env julia
function show(pname,pdb,fa)
    for i in fa
        (c,v) = collect(i)
        println(">$pdb;$c;$pname")
        println(v)
    end
end
function main()
    target = ARGS[1]
    aadict = Dict(
                     "ALA"=> "A",
                     "ASX"=> "B",
                     "CYS"=> "C",
                     "ASP"=> "D",
                     "GLU"=> "E",
                     "PHE"=> "F",
                     "GLY"=> "G",
                     "HIS"=> "H",
                     "ILE"=> "I",
                     "LYS"=> "K",
                     "LEU"=> "L",
                     "MET"=> "M",
                     "ASN"=> "N",
                     "PRO"=> "P",
                     "GLN"=> "Q",
                     "ARG"=> "R",
                     "SER"=> "S",
                     "THR"=> "T",
                     "SEC"=> "U",
                     "VAL"=> "V",
                     "TRP"=> "W",
                     "XAA"=> "X",
                     "TYR"=> "Y",
                     "GLX"=> "Z")
    f = open("$target")
    pdb = split(target,".")[1]
    fa =Dict()
    tmp = 0
    pname = ""
    for buf in eachline(f)
        if ismatch(r"^TITLE",buf)
            pname = lowercase(strip(buf[11:end]))
        end
        if ismatch(r"^ATOM",buf)
            chain = "$(buf[22])"
            num   = parse(strip(buf[23:26]))
            amino = strip(buf[18:20])
            #初期化
            if in(chain,keys(fa)) == false
                fa[chain] = ""
            end
            a1 = aadict[amino]
            if num != tmp
                fa[chain] =fa[chain] * a1
            end
            tmp = num
        end
    end
    show(pname,pdb,fa)
end
main()
