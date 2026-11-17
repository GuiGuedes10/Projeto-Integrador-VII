function NeuralNetwork(_input_size, _hidden_size, _output_size) constructor {
    input_size = _input_size;
    hidden_size = _hidden_size;
    output_size = _output_size;
    
    // Pesos e Vieses
    weights_ih = array_create(hidden_size, 0);
    for (var i = 0; i < hidden_size; i++) {
        weights_ih[i] = array_create(input_size, 0);
        for (var j = 0; j < input_size; j++) {
            weights_ih[i][j] = random_range(-1, 1);
        }
    }
    
    weights_ho = array_create(output_size, 0);
    for (var i = 0; i < output_size; i++) {
        weights_ho[i] = array_create(hidden_size, 0);
        for (var j = 0; j < hidden_size; j++) {
            weights_ho[i][j] = random_range(-1, 1);
        }
    }
    
    bias_h = array_create(hidden_size, 0);
    bias_o = array_create(output_size, 0);
    for(var i = 0; i < hidden_size; i++) bias_h[i] = random_range(-0.5, 0.5);
    for(var i = 0; i < output_size; i++) bias_o[i] = random_range(-0.5, 0.5);

    // Função de Ativação (Sigmoid)
    static activate = function(_val) {
        return 1 / (1 + exp(-_val));
    }

    // Forward Pass (Passo para frente)
    static forward = function(_inputs) {
        var _hidden = array_create(hidden_size, 0);
        for (var i = 0; i < hidden_size; i++) {
            var _sum = bias_h[i];
            for (var j = 0; j < input_size; j++) {
                _sum += _inputs[j] * weights_ih[i][j];
            }
            _hidden[i] = activate(_sum);
        }
        
        var _outputs = array_create(output_size, 0);
        for (var i = 0; i < output_size; i++) {
            var _sum = bias_o[i];
            for (var j = 0; j < hidden_size; j++) {
                _sum += _hidden[j] * weights_ho[i][j];
            }
            _outputs[i] = _sum;
        }
        return _outputs;
    }

    // BACKPROPAGATION (Treinamento da Rede Neural)
    static train = function(_inputs, _target_outputs, _learning_rate = 0.1) {
        // 1. Executa o Forward para obter os valores atuais e da camada oculta
        var _hidden = array_create(hidden_size, 0);
        for (var i = 0; i < hidden_size; i++) {
            var _sum = bias_h[i];
            for (var j = 0; j < input_size; j++) {
                _sum += _inputs[j] * weights_ih[i][j];
            }
            _hidden[i] = activate(_sum);
        }
        
        var _outputs = array_create(output_size, 0);
        for (var i = 0; i < output_size; i++) {
            var _sum = bias_o[i];
            for (var j = 0; j < hidden_size; j++) {
                _sum += _hidden[j] * weights_ho[i][j];
            }
            _outputs[i] = _sum;
        }
        
        // 2. Calcula o erro da saída (Target - Output)
        var _output_errors = array_create(output_size, 0);
        for (var i = 0; i < output_size; i++) {
            _output_errors[i] = _target_outputs[i] - _outputs[i];
        }
        
        // 3. Calcula o erro propagado para a camada oculta
        var _hidden_errors = array_create(hidden_size, 0);
        for (var i = 0; i < hidden_size; i++) {
            var _error = 0;
            for (var j = 0; j < output_size; j++) {
                _error += _output_errors[j] * weights_ho[j][i];
            }
            _hidden_errors[i] = _error;
        }
        
        // 4. Atualiza pesos e vieses da Camada Oculta para a Saída
        for (var i = 0; i < output_size; i++) {
            bias_o[i] += _learning_rate * _output_errors[i];
            for (var j = 0; j < hidden_size; j++) {
                weights_ho[i][j] += _learning_rate * _output_errors[i] * _hidden[j];
            }
        }
        
        // 5. Atualiza pesos e vieses da Entrada para a Camada Oculta
        for (var i = 0; i < hidden_size; i++) {
            var _derivative = _hidden[i] * (1 - _hidden[i]); // Derivada da Sigmoid
            var _grad = _hidden_errors[i] * _derivative;
            bias_h[i] += _learning_rate * _grad;
            for (var j = 0; j < input_size; j++) {
                weights_ih[i][j] += _learning_rate * _grad * _inputs[j];
            }
        }
    }
}