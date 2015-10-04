classdef FilterSet    
    %Contains a matrix defining the change required at each phon
    %level. Effectively a table of scaling levels (in dB) for each phon
    %value. Also provides 'phons' and 'freqs' of this matrix, where 'freqs'
    %is the frequency vector used (x) and 'phons' is the phon level of each
    %set of gains. Just run it, it'll make sense.
    
    % SO:
    
    % m.freqs = frequency values for...
    % m.gains = gain values for aforementioned frequency values at phon
    % levels...
    % m.phons = phon levels represented by each set of gains.
    
    properties 
        phons % Reference phon levels
        gains % Attenuation required per phon level
        freqs % Reference frequencies
    end
    
    properties (Access = private)
        phonMin = 0;
        phonMax = 100;
        phonLevels = 40;
        phonStep;
        freqPoints = 50;
        
        linearFadePoint = 0.6666;
        smoothTransition = 8;
    end
    
    methods
        function obj = FilterSet(model,varargin)
            parser = inputParser;
            addParameter(parser,'smoothing','off');
            addParameter(parser,'transitionflat','off');
            addParameter(parser,'phonMin',0,@isnumeric);
            addParameter(parser,'phonMax',100,@isnumeric);
            addParameter(parser,'phonLevels',40,@isnumeric);
            parse(parser,varargin{:});
            
            obj.phonMin = parser.Results.phonMin;
            obj.phonMax = parser.Results.phonMax;
            obj.phonLevels = parser.Results.phonLevels;
            
            obj.phonStep = ((obj.phonMax-obj.phonMin)/(obj.phonLevels-1));
            
            obj.freqs = model.createFrequencyRange();
            obj.phons = obj.createPhonRange();
            obj.gains = zeros(obj.phonLevels,obj.freqPoints);
            
            % Create point at which to transition to linear for fading to
            % silence
            linearFadePointPhon = round(obj.phonLevels * obj.linearFadePoint);
        
            % Create model from linear scalar
            if strcmp(parser.Results.transitionflat,'on')
                for phon = 1:linearFadePointPhon
                    obj.gains(phon,:) = model.createFilterSpec(phon*obj.phonStep-1);
                end

                % Add interpolated fade to flat at nothing
                for phon = linearFadePointPhon+1:obj.phonLevels
                    correct = (-obj.phonLevels*obj.phonStep-(obj.gains(linearFadePointPhon,:))).*(phon - linearFadePointPhon) / obj.phonLevels / (1 - obj.linearFadePoint);
                    obj.gains(phon,:) = obj.gains(linearFadePointPhon,:) + correct;
                end
            else % Didn't request fading, don't do it
                for phon = 1:obj.phonLevels
                    obj.gains(phon,:) = model.createFilterSpec(phon*obj.phonStep-1);
                end
            end
            
            % Smooth across phon values to remove
            if strcmp(parser.Results.smoothing,'on')
                if obj.smoothTransition
                    for f = 1:obj.freqPoints
                        [Px,Py] = applyBezierSmoothing(obj.gains(:,f),obj.phons,linearFadePointPhon,obj.smoothTransition);
                        obj.gains(:,f) = interp1(Py,Px,obj.phons);
                    end
                end
            end
        end
    end
    
    methods (Access = private) 
        function obj = createPhonRange(self)
            obj = self.phonMin:self.phonStep:self.phonMax;
        end
    end
    
end

