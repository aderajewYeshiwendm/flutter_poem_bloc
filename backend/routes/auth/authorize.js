import jwt from 'jsonwebtoken';
import bcrypt from 'bcryptjs'; // For password comparison

export default function isAdmin(req, res, next) {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (!token) {
        return res.status(401).json({ message: 'Unauthorized: Missing token.' });
    }

    jwt.verify(token, 'secret', (err, decoded) => {
        if (err) {
            return res.status(403).json({ message: 'Forbidden: Invalid token.' });
        }

        // Check if the user is admin with specific credentials
        if (decoded.email === 'admin@gmail.com' && bcrypt.compareSync('adminone', decoded.password)) {
            req.user = decoded; // Set the decoded user information to req.user
        
            next(); // Allow poets to proceed
        } else {
            return res.status(403).json({ message: 'Forbidden: User is not authorized.' });
        }
    });
}
