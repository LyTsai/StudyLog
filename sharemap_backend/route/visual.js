const Visual = require('../models/visuals')

// get
exports.getVisuals = async (req, res) => {
  try {
    let condition = req.query
    let result = await Visual.find(condition)
    res.send(result)
  } catch (error) {
    res.status(404).send(error)
  }
}

// add
exports.addVisual = async (req, res) => {
  //req.body
  let visualData = new Visual (req.body)
  // check before add?
  try {
    let visual= await visualData.save()
    res.status(201).send(visual)
  } catch (error) {
    res.status(500).send(error)
  }
}
// update
// allow add
exports.updateVisualById = async (req, res) => {
  let id = req.body
  if (req.query.id) {
    id = req.query.id
  }
  const updated = req.body
  try {
    let update = await Visual.updateOne({_id: updated._id}, {$set: updated}, {upsert: true})
    res.send(update)
  } catch (error) {
    res.status(500).send(error)
  }
}

// delete
exports.deleteVisualById = async (req, res) => {
  const id = req.query.id
  try {
    let removed = await Visual.remove({_id: id})
    res.send(removed)
  } catch (error) {
    res.status(500).send(error)
  }
}