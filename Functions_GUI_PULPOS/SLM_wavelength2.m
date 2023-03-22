classdef SLM_wavelength2 < handle
    
    properties
        
        % 1x2 vector for x and y sizes
        size;
        % Wavelength of use
        wavelength;
        % driver
        driver;
        % display screen ID
        phaseFactor = 208;
        driver_display
        % SLM tag
        tag = 'SPATIAL LIGHT MODULATOR';
        
    end
    
    properties (Dependent, SetObservable=true)
        
        
        % Turbulence map
        turbmap;
        % Phasemap on the SLM
        phasemap;
        % bitmap
        bitmap
        % flatmap
        flatmap
        % tipmap
        tipmap;
        % ampmap
        ampmap;   
    end
    
    properties (Access=public);%private)
        p_turbmap;
        p_phasemap;
        p_bitmap;
        p_flatmap
        p_tipmap;
        p_ampmap;
        p_phaseFactor;
        p_ampFactor;
        ampFactor;
    end
    
    methods
       
        %% Constructeur
        function obj = SLM_wavelength2(size, varargin)
            
            p = inputParser;
            
            p.addRequired('size',@isnumeric);
            p.addParameter('wavelength', 660e-9);
            p.addParameter('phaseFactor',208);
            
            p.parse(size, varargin{:});
            
            obj.size = p.Results.size;
            obj.wavelength = p.Results.wavelength;
            
            obj.p_turbmap = zeros(size);
            obj.p_phasemap = zeros(size);
            obj.p_flatmap = zeros(size);
            obj.p_tipmap = zeros(size);
            obj.p_ampmap = zeros(size);
            
            obj.p_ampFactor = 0;
            
            display(obj)
        end
        
        %% Display
        function display(obj)
            
            fprintf('___ %s ___\n',obj.tag)
            fprintf(' %dX%d pixels spatial light modulator: \n ',...
                obj.size(1),obj.size(2))
            fprintf('----------------------------------------------------\n')
        end
        
        %% Get/Set phase map
        function out = get.phasemap(obj)
            out = obj.p_phasemap;
        end
        function set.phasemap(obj, val)
            obj.p_phasemap = val;
            [TIP,TILT]=meshgrid(1:size(2),1:size(1));
            
            phase = angle(exp(1i*obj.phasemap).*...
                exp(1i*obj.flatmap).*...
                exp(1i*obj.tipmap).*...
                exp(1i*obj.turbmap).*...
                exp(1i*obj.ampFactor*obj.ampmap.*(TIP+TILT)))+pi;
            bm = uint8(obj.phaseFactor*phase/(2*pi));
            if isa(obj.driver, 'function_handle')
                obj.driver(bm, obj.driver_display)
            end
        end
        
         %% Get/Set turbulence map
        function out = get.turbmap(obj)
            out = obj.p_turbmap;
        end
        function set.turbmap(obj, val)
            obj.p_turbmap = val;
            [TIP,TILT]=meshgrid(1:size(2),1:size(1));            
            
            phase = angle(exp(1i*obj.phasemap).*...
                exp(1i*obj.flatmap).*...
                exp(1i*obj.tipmap).*...
                exp(1i*obj.turbmap).*...
                exp(1i*obj.ampFactor*obj.ampmap.*(TIP+TILT)))+pi;
            bm = uint8(obj.phaseFactor*phase/(2*pi));
            if isa(obj.driver, 'function_handle')
                obj.driver(bm, obj.driver_display)
            end
        end
       
        %% Get/Set bitmap
        function out = get.bitmap(obj)
            [TIP,TILT]=meshgrid(1:size(2),1:size(1));
            
            phase = angle(exp(1i*obj.phasemap).*...
                exp(1i*obj.flatmap).*...
                exp(1i*obj.tipmap).*...
                exp(1i*obj.turbmap).*...
                exp(1i*obj.ampFactor*obj.ampmap.*(TIP+TILT)))+pi;
            bm = uint8(obj.phaseFactor*phase/(2*pi));
            out = bm;
        end
        function set.bitmap(obj, val)
            obj.p_bitmap = val;
            if isa(obj.driver, 'function_handle')
                obj.driver(val, obj.driver_display)
            end
        end
        
        %% Get/Set flatmap
        function out = get.flatmap(obj)
            out = obj.p_flatmap;
        end
        function set.flatmap(obj, val)
            obj.p_flatmap = val;
            [TIP,TILT]=meshgrid(1:obj.size(2),1:size(1));
               
            phase = angle(exp(1i*obj.phasemap).*... % apply +-pi offset (suggested correction) 
                exp(1i*obj.flatmap).*...
                exp(1i*obj.tipmap).*...
                exp(1i*obj.turbmap).*...
                exp(1i*obj.ampFactor*obj.ampmap.*(TIP+TILT)))+pi;
            bm = uint8(obj.phaseFactor*phase/(2*pi));
            if isa(obj.driver, 'function_handle')
                obj.driver(bm, obj.driver_display)
            end
        end
        
        %% Get/Set tip-tilt
        function out = get.tipmap(obj)
            out = obj.p_tipmap;
        end
        function set.tipmap(obj, val)
            obj.p_tipmap = val;
            [TIP,TILT]=meshgrid(1:size(2),1:size(1));
               
            phase = angle(exp(1i*obj.phasemap).*...
                exp(1i*obj.flatmap).*...
                exp(1i*obj.tipmap).*...
                exp(1i*obj.turbmap).*...
                exp(1i*obj.ampFactor*obj.ampmap.*(TIP+TILT)))+pi;
            bm = uint8(obj.phaseFactor*phase/(2*pi));
            if isa(obj.driver, 'function_handle')
                obj.driver(bm, obj.driver_display)
            end
        end
        
                %% Get/Set amplitude map
        function out = get.ampmap(obj)
            out = obj.p_ampmap;
        end
        function set.ampmap(obj, val)
            obj.p_ampmap = val;
            
            [TIP,TILT]=meshgrid(1:size(2),1:size(1));
               
            phase = angle(exp(1i*obj.phasemap).*...
                exp(1i*obj.flatmap).*...
                exp(1i*obj.tipmap).*...
                exp(1i*obj.turbmap).*...
                exp(1i*obj.ampFactor*obj.ampmap.*(TIP+TILT)))+pi;
            bm = uint8(obj.phaseFactor*phase/(2*pi));
            if isa(obj.driver, 'function_handle')
                obj.driver(bm, obj.driver_display)
            end
        end
        
        %% Get/Set amplitude map
        function out = get.ampFactor(obj)
            out = obj.p_ampFactor;
        end
        function set.ampFactor(obj, val)
            obj.p_ampFactor = val;
            
            [TIP,TILT]=meshgrid(1:size(2),1:size(1));
               
            phase = angle(exp(1i*obj.phasemap).*...
                exp(1i*obj.flatmap).*...
                exp(1i*obj.tipmap).*...
                exp(1i*obj.turbmap).*...
                exp(1i*obj.ampFactor*obj.ampmap.*(TIP+TILT)))+pi;
            bm = uint8(obj.phaseFactor*phase/(2*pi));
            if isa(obj.driver, 'function_handle')
                obj.driver(bm, obj.driver_display)
            end
        end
        
        %% Set pyramid phase map
        function obj = pyramid(obj, faces, angle, center, orientation, alternative)
            
       %alternative;                %Alternative =1 creates an alternative phase screen for the 3pwfs. looks like a 4pwfs with one pupil missing.
                                    %Alternative=2 creates the ingot wfs mask  
                                    
                                    %%IF RUNNING ALTERNATIVE ORIENTATION
                                    %%DOESNT CHANGE. SET TO 0
            
            
            
  if alternative==0                      
            Nx = obj.size(1);
            Ny = obj.size(2);
            
            Cx = center(1);
            Cy = center(2);
            
            x = linspace(-Cx+1, Nx-Cx, Nx);
            y = linspace(-Cy+1, Ny-Cy, Ny);
            [x_grid, y_grid] = meshgrid(x, y);
            x_grid = x_grid';
            y_grid = y_grid';
            
            % DEFINE THE SLOPE GRID
            angle_grid = atan2(y_grid*sin(-orientation) + ...
                               x_grid*cos(-orientation), ...
                               y_grid*cos(-orientation) - ...
                               x_grid*sin(-orientation));
            
            % INITIALIZE PYRAMID MASK
            Pyramid = zeros(Nx, Ny);
            for i=0:faces-1
                theta = pi*(1/faces - 1) + i*2*pi/faces + orientation;
                slope = sin(theta)*x_grid + cos(theta)*y_grid;
                slope((-pi+i*2*pi/faces > angle_grid) |...
                      (angle_grid > (-pi+(i + 1)*2*pi/faces))) = 0;
                Pyramid = Pyramid + angle*slope;
            end
             obj.phasemap = Pyramid;
  end
  
  if alternative ==1
      
      %%
            Nx = obj.size(1);
            Ny = obj.size(2);
            
            %%
            orientation=0;
            
            Cx = center(1);
            Cy = center(2);
            
            x = linspace(-Cx+1, Nx-Cx, Nx);
            y = linspace(-Cy+1, Ny-Cy, Ny);
            [x_grid, y_grid] = meshgrid(x, y);
            x_grid = x_grid';
            y_grid = y_grid';
            
            % DEFINE THE SLOPE GRID
            angle_grid = atan2(y_grid*sin(-orientation) + ...
                               x_grid*cos(-orientation), ...
                               y_grid*cos(-orientation) - ...
                               x_grid*sin(-orientation));
            
       % pull out 3PWFS masks
       faces=3;
       s1=zeros(Nx,Ny);
       s2=zeros(Nx,Ny);
       s3=zeros(Nx,Ny);
       for kFaces=0:faces-1
           theta = (pi*(1/faces - 1) + kFaces*2*pi/faces + orientation);
           slope = (sin(theta)*x_grid + cos(theta)*y_grid);
           
           %Take into account the last tile of the pyramid mask
           
           if kFaces == faces-1
               s3((-pi+kFaces*2*pi/faces <= angle_grid) &...
                   (angle_grid < (-pi+(kFaces + 1)*2*pi/faces))) = 1;                else
               if kFaces==0
                   s1((-pi+kFaces*2*pi/faces <= angle_grid) &...
                       (angle_grid <= (-pi+(kFaces + 1)*2*pi/faces))) = 1;
               end
               if kFaces==1
                   s2((-pi+kFaces*2*pi/faces <= angle_grid) &...
                       (angle_grid <= (-pi+(kFaces + 1)*2*pi/faces))) = 1;
               end
           end
       end
       
       %%
       faces = 4;
       
       % INITIALIZE PYRAMID MASK
       
       pyp = zeros(Nx, Ny);
       for kFaces=0:faces-1
           theta = (pi*(1/faces - 1) + kFaces*2*pi/faces + orientation);
           slope = (sin(theta)*x_grid + cos(theta)*y_grid);
           %Take into account the last tile of the pyramid mask
           if kFaces == 3
               slope=slope.*s3;
               pyp = pyp+slope*angle;
           else
               if kFaces==0
                   slope=slope.*s1;
                   pyp = pyp+slope*angle;
               end
               
               if kFaces==1
                   slope=slope.*s2;
                   pyp = pyp+slope*angle;
               end
           end
       end
 %%           
            obj.phasemap = pyp;
            
  end
  
  if alternative==2
      %function obj = pyramidSLM(obj, nFaces, angle, centrePos, rotation, rooftop)
      orientation=pi/2;
      Nx = obj.size(1);
      Ny = obj.size(2);
      
      Cx = center(1);
      Cy = center(2);
      
      x = linspace(-Cx+1, Nx-Cx, Nx);
      y = linspace(-Cy+1, Ny-Cy, Ny);
      [x_grid, y_grid] = meshgrid(x, y);
      x_grid = x_grid';
      y_grid = y_grid';
      
      % DEFINE THE SLOPE GRID
      angle_grid = atan2(y_grid*sin(-orientation) + ...
          x_grid*cos(-orientation), ...
          y_grid*cos(-orientation) - ...
          x_grid*sin(-orientation));
      
      % INITIALIZE PYRAMID MASK
      Pyramid = zeros(Nx, Ny);
      s1=zeros(Nx,Ny);
      s2=zeros(Nx,Ny);
      s3=zeros(Nx,Ny);
      
%       %T0
%       s1((0 <= angle_grid) & (angle_grid < pi/2)) = 1;
%       s2((pi/2 <= angle_grid) & (angle_grid < pi)) = 1;
%        
%       %T15
%       s1((pi/12 <= angle_grid) & (angle_grid < pi/2)) = 1;
%       s2((pi/2 <= angle_grid) & (angle_grid < 11*pi/12)) = 1;
%       
      %T30
      s1((pi/6 <= angle_grid) & (angle_grid < pi/2)) = 1;
      s2((pi/2 <= angle_grid) & (angle_grid < 5*pi/6)) = 1;
      
      
      s=s1+s2;
      s3=s<1;
      %% Apply 4PWFS tilts
      nFaces_ = 4;
      % INITIALIZE PYRAMID MASK
      pyp = zeros(Nx, Ny);
      for kFaces=0:nFaces_-1
          theta = (pi*(1/nFaces_ - 1) + kFaces*2*pi/nFaces_ + orientation);
          slope = (sin(theta)*x_grid + cos(theta)*y_grid);
          %Take into account the last tile of the pyramid mask
          if kFaces == 2
              slope=.5*y_grid.*s3;
              pyp = pyp+angle*slope;
          else
              if kFaces==0
                  slope=slope.*s1;
                  pyp = pyp+angle*slope;
              end
              if kFaces==1
                  slope=slope.*s2;
                  pyp = pyp+angle*slope;
                  pyp=-pyp;
              end
          end
      end
      
      obj.phasemap = pyp;
  end
  

  
        end
        
        %% Set pyramid phase map
        function obj = vortex(obj, center, charge)
                        
            Nx = obj.size(1);
            Ny = obj.size(2);
            
            Cx = center(1);
            Cy = center(2);
            
            x = linspace(-Cx+1, Nx-Cx, Nx);
            y = linspace(-Cy+1, Ny-Cy, Ny);
            [x_grid, y_grid] = meshgrid(x, y);
            x_grid = x_grid';
            y_grid = y_grid';
            
            % DEFINE THE SLOPE GRID
            angle_grid = atan2(y_grid, x_grid);
            
            % INITIALIZE PYRAMID MASK
            Vortex = angle_grid*charge;
            obj.phasemap = Vortex;
            
        end
        
        %% Set pyramid phase map
        function obj = Zelda(obj, center, radius, phase_shift)
                        
            Nx = obj.size(1);
            Ny = obj.size(2);
            
            Cx = center(1);
            Cy = center(2);
            
            x = linspace(-Cx+1, Nx-Cx, Nx);
            y = linspace(-Cy+1, Ny-Cy, Ny);
            [x_grid, y_grid] = meshgrid(x, y);
            x_grid = x_grid';
            y_grid = y_grid';
            
            % DEFINE THE POSITION GRID
            position_grid = sqrt(x_grid.^2 + y_grid.^2);
            
            % INITIALIZE ZELDA MASK
            Zelda = zeros(Nx, Ny);
            Zelda(position_grid <= radius) = phase_shift;
            obj.phasemap = Zelda;
            
        end
        %% Set FQPM phase map
        function obj = FQPM(obj, phase_shift, center)
            
            Cx = center(1);
            Cy = center(2);
            Nx = obj.size(1);
            Ny = obj.size(2);
            
            FQPM = phase_shift*[zeros(Cx, Cy), ...
                                     ones(Cx, Ny-Cy); ...
                                     ones(Nx-Cx, Cy), ...
                                     zeros(Nx-Cx, Ny-Cy)];
            
            obj.phasemap = FQPM;
        end
        
        %% Phase to bitmap
        function obj = phase2bitmap(obj, wavelength)
            obj.bitmap = uint8(obj.phaseFactor*(angle(exp(1i*(obj.phasemap)))+pi)/...
                                                                (2*pi));
        end
    end
    
end