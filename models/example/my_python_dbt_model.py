def model(dbt, session):
    # Get the input relation as a BigFrames DataFrame
    df = dbt.ref('my_first_dbt_model')

    # Example transformation: filter out null ids and add a new column
    df = df[df['id'].notnull()]
    df['id_squared'] = df['id'] ** 2

    return df
