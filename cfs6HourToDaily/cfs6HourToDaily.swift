type file;
type script;

app (file o) cdo (script exec, string input, string result){
    bash @exec input result stdout=@o;
}

string input_dir  = @arg("6hour", "/scratch/midway/yadunand/CFS/cfs6HourToDaily/6hour");
string output_dir = @arg("daily", "/scratch/midway/yadunand/CFS/cfs6HourToDaily/daily");

file prate6hour[] <filesys_mapper; location=input_dir, suffix="grb2">;
//file prate6hour[] <filesys_mapper; location="./", suffix="grb2">;
script daymean <"daymean.sh">;

foreach hour6 in prate6hour{
    tracef("6hour file : %s \n", @filename(hour6));
    string b[] = @strsplit(@filename(hour6), "/");
    int last = @length(b);
    tracef("Last = %s Second last = %s \n", b[last-1], b[last-2]);
    //file daily_out <single_file_mapper; location=ouput_dir, file=@strcat("./daily_", b[last-1])>;

    file daily_err <single_file_mapper; file=@strcat(@strcat("./logs/", b[last-1]),".err")>;
    //(daily_err) = cdo (daymean, @strcat("/",@filename(hour6)), @filename(daily_out) );
    (daily_err) = cdo (daymean, @strcat("/",@filename(hour6)), output_dir );
}

