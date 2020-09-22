-- SGS: Sistema de Gerenciamento de Simulações
-- Create statement do BD

-- Criação do Schema
CREATE SCHEMA sgs;

-- Criação tabela sgs.session
CREATE TABLE sgs.session (
    id SERIAL PRIMARY KEY,
    cluster_p3d_filepath TEXT,
    p3d_sent_to_cluster BOOLEAN DEFAULT FALSE,
    owner TEXT,
    status_id INTEGER,
    simulation_start_at TIMESTAMP,
    simulation_finished_at TIMESTAMP,
    simulation_active BOOLEAN DEFAULT FALSE,
    dynasim_version TEXT,
    bin_files_folder_path TEXT,
    transformation_start_at TIMESTAMP,
    transformation_finished_at TIMESTAMP,
    transformation_active BOOLEAN DEFAULT FALSE,
    output_files_folder_path TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Criação função para update de modifcações
CREATE OR REPLACE FUNCTION update_modified_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Criação de trigger para chamar a função de atualização do campo updated_at
CREATE TRIGGER updated_at
BEFORE UPDATE ON sgs.session
FOR EACH ROW
EXECUTE PROCEDURE update_modified_column();

-- Criação da tabela sgs.p3d
CREATE TABLE sgs.p3d (
    id SERIAL PRIMARY KEY,
    p3d_blueprint_id INTEGER,
    session_id INTEGER,
    p3d_string TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Criação de trigger para chamar a função de atualização do campo updated_at
CREATE TRIGGER updated_at
BEFORE UPDATE ON sgs.p3d
FOR EACH ROW
EXECUTE PROCEDURE update_modified_column();

CREATE TABLE sgs.p3d_blueprint (
    id SERIAL PRIMARY KEY,
    name TEXT,
    platform_name TEXT,
    description TEXT,
    content TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Criação de trigger para chamar a função de atualização do campo updated_at
CREATE TRIGGER updated_at
BEFORE UPDATE ON sgs.p3d_blueprint
FOR EACH ROW
EXECUTE PROCEDURE update_modified_column();

-- Criação da tabela sgs.combination
CREATE TABLE sgs.combination (
    id SERIAL PRIMARY KEY,
    session_id INTEGER,
    p3d_blueprint_id INTEGER,
    wave_hs FLOAT,
    wave_tp FLOAT,
    wave_dir FLOAT,
    swell_hs FLOAT,
    swell_tp FLOAT,
    swell_dir FLOAT,
    total_hs FLOAT,
    wind_speed FLOAT,
    wind_dir FLOAT,
    current_speed FLOAT,
    current_dir FLOAT,
    lines TEXT,
    rupture_time FLOAT,
    export_type TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Criação de trigger para chamar a função de atualização do campo updated_at
CREATE TRIGGER updated_at
BEFORE UPDATE ON sgs.combination
FOR EACH ROW
EXECUTE PROCEDURE update_modified_column();

-- Criação da tabela sgs.session_status
CREATE TABLE sgs.session_status (
    id SERIAL PRIMARY KEY,
    code TEXT,
    description TEXT,
    priority INTEGER,
    processing BOOLEAN,
    active BOOLEAN,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Criação de trigger para chamar a função de atualização do campo updated_at
CREATE TRIGGER updated_at
BEFORE UPDATE ON sgs.session_status
FOR EACH ROW
EXECUTE PROCEDURE update_modified_column();


-- Criação da tabela sgs.output
CREATE TABLE sgs.output (
    id SERIAL PRIMARY KEY,
    session_id INTEGER,
    combination_id INTEGER,
    input_filepath TEXT,
    output_filepath TEXT,
    export_type TEXT,
    successful_simulation BOOLEAN,
    successful_transformation BOOLEAN,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Criação de trigger para chamar a função de atualização do campo updated_at
CREATE TRIGGER updated_at
BEFORE UPDATE ON sgs.output
FOR EACH ROW
EXECUTE PROCEDURE update_modified_column();

-- Insert dos status
INSERT INTO sgs.session_status (code,description,priority,processing,active)
VALUES
('WAITING_SIMULATION','A sessão está aguardando execução da simulação',10,FALSE,TRUE),
('RUNNING_SIMULATION','A simulação referente à sessão está sendo executada no cluster do TPN',20,TRUE,TRUE),
('WAITING_TRANSFORMATION','A sessão está aguardando a execução da etapa de transformação',30,FALSE,TRUE),
('RUNNING_TRANSFORMATION','A transformação referente à sessão está sendo executada no cluster do TPN',40,TRUE,TRUE),
('SESSION_COMPLETE','A sessão de simulação está completa',0,FALSE,FALSE),
('SIMULATION_ERROR','Ocorreu um erro durante a simulação',1,FALSE,FALSE),
('TRANSFORMATION_ERROR','Ocorreu um erro durante a transformação',2,FALSE,FALSE);

-- Set timezone to 'America/Sao_Paulo'
SET TIMEZONE='America/Sao_Paulo';
