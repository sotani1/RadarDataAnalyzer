function M_data = f_cm2_2_set_fieldnames(num_mt_tmp)
%% ��2-1-3-3-4-2 && ��2-1-3-3-4-3-2 Set variables in "M_data"
M_data    = [];
data      = [];

%% ��2-1-3-3-4-2-1 Create M_data lists by amount of microtrips (Currently disabled)
for i=1 : num_mt_tmp
    microtrip{i} = i;
end
%% ��2-1-3-3-4-2-2 Set dictionary class for 'variables' and 'ansi string'
type      = {'var', 'as'};
%% ��2-1-3-3-4-2-3 Set amount of radar targets here
target    = {'ego',     'track1',  'track2',  'track3',  'track4',  ... 
             'track5',  'track6',  'track7',  'track8',  'track9',  ... 
             'track10', 'track11', 'track12', 'track13', 'track14', ...
             'track15', 'track16', 'lead',    'env'};
%% ��2-1-3-3-4-2-4 Set list of variables you want to observe here
variable  = {'posx',      'speedx',        'accelx',        'jerkx',        'ILV',        ...
             'thw',       'ttc',           'thw_inv',       'ttc_inv',      'ttc_delta',  ...
             'thw_delta', 'ttc_delta_inv', 'thw_delta_inv', 'apo',          'bksw',       ... 
             'swa',       'posy',          'curve',         'lat_dist',     'width',      ...
             'latitude',  'longitude'};
%% ��2-1-3-3-4-2-5 Set tuple list for 'Is Lead Vehicle' parameters
ilv       = {'non_ilv', 'ilv'};
%% ��2-1-3-3-4-2-6 Construct "M_data" structure here (Empty Box)
M_data    = struct('microtrip', microtrip, 'type',     ...
            struct('type',      type,      'target',   ...
            struct('target',    target,    'variable', ...  
            struct('variable',  variable,  'ilv',      ...
            struct('ilv',       ilv,       'data',     ...
            struct('data',      data))))));
        
