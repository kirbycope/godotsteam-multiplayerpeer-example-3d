extends GPUParticles3D

func _ready():
	# Create the particle material
	var particle_material = ParticleProcessMaterial.new()
	
	# Emission shape (box)
	particle_material.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	particle_material.emission_box_extents = Vector3(15, 5, 15)  # Half the desired size (30x10x30)
	
	# Particle properties
	particle_material.direction = Vector3(0, 1, 0)
	particle_material.spread = 5.0
	particle_material.gravity = Vector3(0, -0.05, 0)  # Very slight downward pull
	particle_material.initial_velocity_min = 0.2
	particle_material.initial_velocity_max = 0.4
	
	# Random motion
	particle_material.turbulence_enabled = true
	particle_material.turbulence_noise_strength = 0.2
	particle_material.turbulence_noise_scale = 2.0
	
	# Lifetime and amount
	particle_material.particle_flag_disable_z = false
	particle_material.lifetime_randomness = 0.5
	
	# Apply the material
	self.process_material = particle_material
	
	# Particle mesh (small sphere or quad)
	var particle_mesh = QuadMesh.new()
	particle_mesh.size = Vector2(0.1, 0.1)
	self.draw_pass_1 = particle_mesh
	
	# Particle system properties
	self.amount = 1000
	self.lifetime = 20.0
	self.explosiveness = 0.0
	self.randomness = 1.0
	self.visibility_aabb = AABB(Vector3(-15, -5, -15), Vector3(30, 10, 30))
	
	# Start emitting
	self.emitting = true
