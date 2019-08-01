function struct2h5(file, dataset, struct)
%Recursive function to write structures in h5 format.
%The function will also iterate through 1D cell arrays and save as
%individual datasets.
%Only supported file types int, double, struct char and strings, and cells
%containing the mentioned variable types.
%Part of Spectral Measurements
%Copyright NYU 2019
%Develloped by Juan Villegas, 08/01/2019
    if nargin == 2
        dataset = '/dataset';
    end  
    fn = fieldnames(struct);
    for k=1:numel(fn)
        field = struct.(fn{k});
        dataset2 = [dataset,'/',fn{k}];
        if( isstruct(field) )
            struct2h5(file, dataset2,field);
        else
            if ~isempty(field)
                if iscell(field)
                    for i = 1: length(field)
                        datasetn = [dataset2,'/',num2str(i)];
                        struct2h5(file,datasetn,field{i});
                    end
                elseif isstring(field) || ischar(field)
                    str2h5(file,dataset2,field);
                else
                    h5create(file,dataset2,size(field));
                    h5write(file,dataset2,field);
                end
            else
                h5create(file,dataset2,1);
            end
        end
    end   
end


function str2h5(filename,dataset,field)
%This function uses low level H5 calls to write char and strings to H5 files.
%Part of Spectral Measurements
%Copyright NYU 2019
%Develloped by Juan Villegas 08/01/2019

    cfield = char(field);
    DIM0 = size(cfield,1); 
    SDIM = size(cfield,2)+1;

    file_id = H5F.open(filename,'H5F_ACC_RDWR','H5P_DEFAULT');  %Open the h5 file

    %Create file and memory datatype
    type_id = H5T.copy ('H5T_C_S1');
    H5T.set_size (type_id, SDIM-1);
    mem_id = H5T.copy ('H5T_C_S1');
    H5T.set_size (mem_id, SDIM-1);
    
    % Create dataspace.  Setting maximum size to [] sets the maximum
    % size to be the current size.
    space_id = H5S.create_simple (1,fliplr( DIM0), []);

    % Create the dataset and write the string data to it.
    dataset_id = H5D.create (file_id, dataset, type_id, space_id, 'H5P_DEFAULT');
    
    % Transpose the data to match the layout in the H5 file to match C
    % generated H5 file.
    H5D.write (dataset_id, mem_id, 'H5S_ALL', 'H5S_ALL', 'H5P_DEFAULT', cfield);
    
    %Close and release resources
    H5D.close(dataset_id);
    H5S.close(space_id);
    H5T.close(type_id);
    H5F.close(file_id);
end