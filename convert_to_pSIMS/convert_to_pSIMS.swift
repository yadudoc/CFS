type file;
type script;

app (file o) cdo_merge (script exec, string input, string result){
    bash @exec input result stdout=@o;
}

string input_dir  = arg("daily",  "/scratch/midway/yadunand/CFS/convert_to_pSIMS/sample");
string output_dir = arg("output", "/scratch/midway/yadunand/CFS/convert_to_pSIMS/merged_grb2");



file prateDaily[] <filesys_mapper; location=@strcat(input_dir,"/prate"), suffix="grb2">;
file prate6hour[] <filesys_mapper; location="./", suffix="grb2">;
script merger <"merge.sh">;

foreach daily in prateDaily{
    tracef("Daily prate file : %s \n", filename(daily));

    string b[] = strsplit(filename(daily), "/");
    int last = length(b);
    tracef("Last = %s Second last = %s \n", b[last-1], b[last-2]);
    file daily_out <single_file_mapper; file=@strcat("./logs/merge_", b[last-1])>;

    daily_out = cdo_merge(merger, filename(daily), output_dir);
}

