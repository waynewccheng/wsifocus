classdef TileClass
    
    properties (Constant)
        folder_name = 'tiles';
    end
    
    methods (Static)
        
        function clean
            delete([TileClass.folder_name '/*.*'])
        end
        
        function save (n_row, n_col, tilergb)
            fn = TileClass.filename_maker(n_row,n_col);
            imwrite(tilergb,fn);
        end
        
        function mat_v = reconstruct (n_y, n_x)
            mat_v = [];
            for j = 1:n_y
                mat_h = [];
                for i = 1:n_x
                    fn = TileClass.filename_maker(j,i);
                    tile = imread(fn);
                    mat_h = [mat_h tile];
                end
                mat_v = [mat_v; mat_h];
            end
        end
        
        function fn = filename_maker (n_row,n_col)
            fn = sprintf('%s/t%03d_%03d.png',TileClass.folder_name,n_row,n_col);
        end
        
    end
end