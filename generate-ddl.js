// node esi2ddl.js --file=../../esi/public/swagger.json --schema=esiv1_10_1 --roles=authenticated,api --database=racopub --out=esi-v1.10.1.sql


const { Client } = require('pg')
const argv = require('yargs').argv
const fs = require('fs')
const request = require('request')

function main() {
  if (argv.file) {
    const f = fs.readFileSync(argv.file);
    run(JSON.parse(f))
  } else if (argv.url) {
    request({
      url: argv.url,
      json: true
    }, function (error, response, body) {
      if (error) {
        console.log(error)
        process.exit(-1)
        run(body)
      }
    })
  }
} main()

function run(spec) {
  let mapping = {
    title: spec.info.title,
    version: spec.info.version,
    description: spec.info.description,
    schema: `esi_v${spec.info.version.replace(/\./ig, '_')}`,
    protected_role: argv.roles.split(',')[0],
    public_role: argv.roles.split(',')[1],
    esi_roles: new Set(),
    database: argv.database,
    tables: []
  }
  // Create Tables from paths
  Object.keys(spec.paths).forEach(p => {
    const path = spec.paths[p].get
    if (!path)
      return
    let table = {
      name: path2table(p),
      description: path.summary,
      operation: path.operationId,
      required_roles: expandRequiredRoles(path['x-required-roles'], mapping.esi_roles),
      columns: {}
    }
    mapping.tables.push(table)
    // params columns
    path.parameters.forEach(param => {
      let schema, name
      if (param.$ref) {
        if (param.$ref === '#/parameters/token') {
          table.protected = true
//          if (!table.required_roles) { // This table is for authenticated character, add user_id
            name = 'user_id'
            schema = {
              type: 'string',
              required: true,
              description: "Authenticated Character Id",
              custom: "varchar(20) not null references auth.users(user_id) DEFAULT current_user"
            }
//          }
        }
        else {
          name = param.$ref.replace('#/parameters/', '')
          schema = spec.parameters[name]
        }
      }
      else {
        schema = param
        name = param.name
      }
      if (schema && !table.columns[name] && schema.required) {
        // for array types in request params, format plain string
        if (schema.type === 'array') {
          schema.format = 'string'
        }
        addColumn(schema, table, name)
      }
    })
    // Primary Key
    let schema = path.responses['200'].schema
    if (schema.type !== 'array') {
      let pk = Object.values(table.columns).filter(c => c.path)
      if (pk.length === 1) {
        pk[0].primary = true
      }
    }
    fillColumnsFromSchema(schema, table)
  })

  if (argv.out) {
    fs.writeFile(argv.out, toSql(mapping), (err) => {
      if (err) throw err;
      console.log(`The file has been saved to ${argv.out}!`);
    });
  } else {
    console.log(JSON.stringify(toSql(mapping)))
  }
}

function fillColumnsFromSchema(schema, table, prefix) {
  if (!prefix) prefix = ''
  switch (schema.type) {
    case 'object': {
      Object.keys(schema.properties).forEach(prop => {
        const property = schema.properties[prop]
        // if (property.type === 'object')
        //   fillColumnsFromSchema(property, table, `${prefix}${prop}`)
        // else
          addColumn(property, table, `${prefix}${prop}`, schema.required && schema.required.find(p => prop === p) !== undefined)
      })
      break;
    }
    case 'array': return fillColumnsFromSchema(schema.items, table, prefix)
    case 'integer':
    case 'number': {
      table.type = 'primitive'
      return addColumn(schema, table, `${prefix}${table.name.replace(/.+_/g, '')}_id`)
    }
    default: throw `Unknown model type: ${schema.type} for ${schema.title}`
  }
}

function addColumn(schema, table, name, required) {
  if (!table.columns[name]) {
    let c = {
      name: name,
      cname: to31Char(name),
      type: esi2dbtype(schema.type, schema.format),
      required: schema.required || required,
      custom: schema.custom,
      description: schema.description,
    }
    if (schema.in && schema.in === 'path') {
      c.path= true
    }
    table.columns[name] = c
  }
}

function esi2dbtype(t, f) {
  switch (t) {
    case 'string':
      switch (f) {
        case 'date': return 'date'
        case 'date-time': return 'timestamp'
        case undefined: return 'varchar'
        default: throw `unknown format: ${f}, type: ${t}`
      }
    case 'integer':
      switch (f) {
        case 'int32': return 'integer'
        case undefined: return 'integer'
        case 'int64': return 'bigint'
        default: throw `unknown format: ${f}, type: ${t}`
      }
    case 'boolean': return 'boolean'
    case 'number':
      switch (f) {
        case 'float': return 'float'
        case 'double': return 'double precision'
        default: throw `unknown format: ${f}, type: ${t}`
      }
    case 'array':
      switch (f) {
        case 'string': return 'varchar'
        default: return 'json'
      }
    case 'object': return 'json'
  }
  let err = new Error(`unknown type: ${t}, format: ${f}`)
  Error.captureStackTrace(err, esi2dbtype)
  throw err
}

function path2table(path) {
  let res = ''
  let tks = path.replace(/^\s*\/+|\s*\/+$/g, '').split('/')
  tks.forEach((s, i) => {
    let tk = s.replace(/\{|\}|_id/g, '')
      .replace('division', 'div')
      .replace(/ies$/, 'y')
    if (!tk.endsWith('us'))
      tk = tk.replace(/s$/, '')
    if (tks.length === 1) {
      res += s
    } else if (i === 0) { // first word becomes a prefix
      if (tks.length == 2 && tks[1].startsWith('{') && tks[1].includes(tk)) {
        res += tk
      }
      else
        res += tk.replace('alliance', 'ali')
          .replace('calendar', 'cal')
          .replace('character', 'chr')
          .replace('corporation', 'crp')
          .replace('dogma', 'dgm')
          .replace('fleet', 'flt')
          .replace('incursions', 'ics')
          .replace('industry', 'ind')
          .replace('insurance', 'ins')
          .replace('killmail', 'km')
          .replace('loyalty', 'lty')
          .replace('market', 'mkt')
          .replace('opportunity', 'opp')
          .replace('search', 'srch')
          .replace('sovereignty', 'sov')
          .replace('universe', 'uni')
          .replace('contract', 'con')
          + '_'
    } else if (i === tks.length - 1) { // last word may indicate details
      res += tks[i-1].includes(tk) ? res.endsWith('_') ? 'dtl' : '' : tk
    } else if (!tks[i-1].includes(tk)) // skip repetitions
      res += tk + '_'
  })
  if (res.length > 30) throw `table name > 31: ${res}, tks: ${tks}`
  return res
}

function toSql(mapping) {
  let sql = []
  sql.push(`-- ${mapping.title} v${mapping.version}`)
  sql.push(`-- ${mapping.description}`)
  sql.push(`--`)
  sql.push(`DROP ROLE IF EXISTS ${mapping.schema};`)
  sql.push(`CREATE ROLE ${mapping.schema};`)
  sql.push(`CREATE SCHEMA AUTHORIZATION ${mapping.schema};`)
  sql.push(`GRANT ${mapping.schema} TO esi;`)
  sql.push(`GRANT USAGE ON SCHEMA ${mapping.schema} TO authenticated;`)

  sql.push(`DROP ROLE IF EXISTS ${[...mapping.esi_roles].join(',')};`)
  mapping.esi_roles.forEach(r => {
    sql.push(`CREATE ROLE ${r};`)
    sql.push(`GRANT authenticated to ${r};`)
  })
  sql.push('--')
  sql.push(`SET SEARCH_PATH TO ${mapping.schema};`)
  sql.push(`--`)
  mapping.tables.forEach(t => {
    sql.push(`-- ${t.description}`)
    sql.push(`-- operation id: ${t.operation}`)
    sql.push(`CREATE TABLE ${t.name}`)
    sql.push(`(`)
    let columns = Object.keys(t.columns)
    columns.forEach((cn, i) => {
        const c = t.columns[cn]
        c.custom
          ? sql.push(`  ${c.cname} ${c.custom}${i < columns.length -1 ? ',':''}`)
          : sql.push(`  ${c.cname} ${c.type}${c.type === 'varchar' ? '(4000)' : ''}${c.primary ? ' PRIMARY KEY' : c.required? ' NOT NULL': ''}${i < columns.length -1 ? ',':''}`)
    })
    sql.push(`);`)
    sql.push(`ALTER TABLE ${t.name} OWNER TO ${mapping.schema};`)
    if (t.protected) {
      sql.push(`GRANT SELECT ON TABLE ${t.name} TO ${t.required_roles? t.required_roles.join(',') : t.protected ? mapping.protected_role : mapping.public_role};`)
      sql.push(`GRANT INSERT ON TABLE ${t.name} TO ${t.required_roles? t.required_roles.join(',') : t.protected ? mapping.protected_role : mapping.public_role};`)
      sql.push(`GRANT DELETE ON TABLE ${t.name} TO ${t.required_roles? t.required_roles.join(',') : t.protected ? mapping.protected_role : mapping.public_role};`)
      sql.push(`ALTER TABLE ${t.name} ENABLE ROW LEVEL SECURITY;`)
      // if (t.required_roles) {
      //   sql.push(`CREATE POLICY ${t.name} ON ${t.name} TO ${t.required_roles.join(',')} USING (corporation_id = current_setting('corporation_id')::INTEGER);`)
      // }
      // else {
        sql.push(`CREATE POLICY ${t.name} ON ${t.name} TO ${mapping.protected_role} USING (user_id = current_user);`)
      // }
    }
    sql.push('')
  })
  // SPEC
  sql.push('-- Swagger Mapping\n' +
    'CREATE TABLE swagger_mapping\n' +
    '(\n' +
    '  version varchar(50) NOT NULL,\n' +
    '  description varchar(255),\n' +
    '  mapping text not null\n' +
    ');\n' +
    `ALTER TABLE swagger_mapping OWNER TO ${mapping.schema};`)
  sql.push(`INSERT INTO swagger_mapping(version, description, mapping) VALUES ('${mapping.version}', '${mapping.description}', '${toSwaggerMapping(mapping)}');`)
  return sql.join('\n')
}

function toSwaggerMapping(mapping) {
  let res = {
    title: mapping.title,
    version: mapping.version,
    description: mapping.description,
    operations: {}
  }
  mapping.tables.forEach(t => {
    let op = {
      table: t.name,
      type: t.type,
      fields: {}
    }
    res.operations[t.operation] = op
    Object.values(t.columns).forEach(c => {
      if (c.path) {
        if (!op.key) {
          op.key = []
        }
        op.key.push(c.name)
      }
      op.fields[c.name] = c.cname
    })
  })
  return JSON.stringify(res).replace(/'/g,'\\\'')
}

function expandRequiredRoles(roles, esi_roles) {
  if (roles) {
    // role system is on the op, so at least CEO should have it
    if (roles.length === 0 ) {
      roles.push('CEO')
    }
    roles.forEach(r => esi_roles.add(r))
  }
  return roles
}

function to31Char(n) {
  if (n === 'from')
    n = `"${n}"`
  if (n.length <= 31)
    return n
  let h = '' + hashCode(n)
  let cut = n.length - 31 + h.length
  return n.substr(0, (n.length - cut) / 2) + h + n.substring((n.length + cut) / 2)
}

function hashCode(s) {
  let h;
  for(let i = 0; i < s.length; i++)
    h = Math.imul(31, h) + s.charCodeAt(i) | 0
  return Math.abs(h)
}
