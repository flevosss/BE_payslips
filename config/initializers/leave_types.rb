# Load leave types from config file
LEAVE_TYPES_SELECT = YAML.load_file(Rails.root.join('config', 'leave_types.yml'))['leave_types']

