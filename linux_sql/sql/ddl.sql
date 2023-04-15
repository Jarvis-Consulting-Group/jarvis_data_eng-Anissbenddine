-- Step 1: Switch to host_agent database
\c host_agent

-- Step 2: Create host_info table if not exists
CREATE TABLE IF NOT EXISTS host_info (
    id SERIAL PRIMARY KEY,
    hostname VARCHAR(255) NOT NULL,
    cpu_number INTEGER,
    cpu_architecture VARCHAR(50),
    cpu_model VARCHAR(255),
    cpu_mhz REAL,
    l2_cache INTEGER,
    total_mem INTEGER NOT NULL,
    timestamp TIMESTAMP NOT NULL
);

-- Step 3: Create host_usage table if not exists
CREATE TABLE IF NOT EXISTS host_usage (
    id SERIAL PRIMARY KEY,
    timestamp TIMESTAMP NOT NULL,
    host_id INTEGER NOT NULL REFERENCES host_info(id),
    memory_free INTEGER NOT NULL,
    cpu_idle REAL NOT NULL,
    cpu_kernel REAL NOT NULL,
    disk_io INTEGER NOT NULL,
    disk_available INTEGER NOT NULL
);