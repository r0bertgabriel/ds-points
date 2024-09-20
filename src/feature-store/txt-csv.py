import os
import pandas as pd

def read_txt_file(file_path):
    separators = [';', ',', '\t', '|', ' ']
    for sep in separators:
        try:
            df = pd.read_csv(file_path, sep=sep)
            return df
        except Exception as e:
            continue
    raise ValueError(f"Could not read the file {file_path} with any of the separators.")

def convert_txt_to_csv(directory):
    txt_files = [f for f in os.listdir(directory) if f.endswith('.txt')]
    csv_directory = os.path.join(directory, 'csv')
    os.makedirs(csv_directory, exist_ok=True)

    for txt_file in txt_files:
        txt_path = os.path.join(directory, txt_file)
        try:
            df = read_txt_file(txt_path)
            csv_file = os.path.splitext(txt_file)[0] + '.csv'
            csv_path = os.path.join(csv_directory, csv_file)
            df.to_csv(csv_path, sep=';', index=False)
            print(f"Converted {txt_file} to {csv_file}")
        except Exception as e:
            print(f"Failed to convert {txt_file}: {e}")

if __name__ == "__main__":
    current_directory = os.path.dirname(os.path.abspath(__file__))
    convert_txt_to_csv(current_directory)