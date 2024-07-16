import json

def lambda_handler(event, context):
    # Procesar el evento aquí
    print("Event: ", json.dumps(event))
    # Lógica de procesamiento
    return {
        'statusCode': 200,
        'body': json.dumps('Procesado correctamente')
    }
