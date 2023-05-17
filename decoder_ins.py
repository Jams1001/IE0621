def decode_instructions(input_file, output_file):
    opcode_dict = {
        "0110111": "U-Type",
        "0010111": "U-Type",
        "1101111": "J-Type",
        "1100111": "I-Type",
        "1100011": "B-Type",
        "0000011": "I-Type",
        "0100011": "S-Type",
        "0010011": "I-Type",
        "0110011": "R-Type"
    }

    with open(input_file, 'r') as fin, open(output_file, 'w') as fout:
        lines = fin.readlines()
        for i in range(0, len(lines), 4):
            # Combine the 4 lines in little endian order and pad with zeros
            instruction = ''.join(line.strip().zfill(8) for line in lines[i:i+4][::-1])
            opcode = instruction[-7:]  # Extract the opcode from the last 7 bits
            instruction_type = opcode_dict.get(opcode, "Unknown")
            fout.write(instruction_type + "\n")

decode_instructions("./tb/tb_core_icarus/binario2.txt", "instrucciones_decodificadas.txt")
