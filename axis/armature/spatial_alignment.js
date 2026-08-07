import * as THREE from 'three';

/**
 * Normalizes spatial origins, bounding box dimensions, and transform matrices
 * between a target proxy mesh (Voodoo Doll) and a resource model.
 * 
 * @param {THREE.Object3D} resourceMesh - Primary source geometry envelope
 * @param {THREE.Object3D} voodooDollMesh - Secondary proxy/target mesh
 * @returns {Function} Frame update function for matrix synchronization
 */
export function alignSpatialEnvelopes(resourceMesh, voodooDollMesh) {
  console.log("[ALIGNMENT] Computing AABB bounding boxes and centers...");

  // Step 1: Compute AABB Bounding Boxes & Centers
  const resourceBox = new THREE.Box3().setFromObject(resourceMesh);
  const dollBox = new THREE.Box3().setFromObject(voodooDollMesh);

  const resourceCenter = resourceBox.getCenter(new THREE.Vector3());
  const dollCenter = dollBox.getCenter(new THREE.Vector3());

  const resourceSize = resourceBox.getSize(new THREE.Vector3());
  const dollSize = dollBox.getSize(new THREE.Vector3());

  // Step 2: Normalize Scale Ratio (Primary Y-Axis Alignment)
  if (dollSize.y > 0) {
    const scaleFactor = resourceSize.y / dollSize.y;
    voodooDollMesh.scale.set(scaleFactor, scaleFactor, scaleFactor);
    
    // Recompute target bounding box post-scale
    dollBox.setFromObject(voodooDollMesh);
    dollBox.getCenter(dollCenter);
  }

  // Step 3: Translate Target Origin to Match Source Center
  const offset = new THREE.Vector3().subVectors(resourceCenter, dollCenter);
  voodooDollMesh.position.add(offset);

  // Step 4: Parent & Link Transformation Matrices
  resourceMesh.add(voodooDollMesh);
  voodooDollMesh.matrixAutoUpdate = false;

  console.log("[ALIGNMENT] Spatial origin & scale ratio locked.");

  // Return continuous transformation frame sync routine
  return function syncMatrixFrame() {
    resourceMesh.updateMatrixWorld(true);
    voodooDollMesh.matrix.copy(resourceMesh.matrixWorld);
  };
}
