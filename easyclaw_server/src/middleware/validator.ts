/**
 * 请求验证中间件
 */
import { Request, Response, NextFunction } from 'express';
import { ApiResponse } from '../types';

/**
 * 验证 Content-Type
 */
export const validateJsonContent = (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  if (req.method === 'POST' || req.method === 'PUT' || req.method === 'PATCH') {
    const contentType = req.headers['content-type'];
    if (!contentType || !contentType.includes('application/json')) {
      const response: ApiResponse = {
        success: false,
        error: {
          code: 'BAD_REQUEST',
          message: 'Content-Type must be application/json'
        }
      };
      res.status(400).json(response);
      return;
    }
  }
  next();
};

/**
 * 简单的请求日志
 */
export const requestLogger = (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  const start = Date.now();
  
  res.on('finish', () => {
    const duration = Date.now() - start;
    console.log(
      `[${new Date().toISOString()}] ${req.method} ${req.path} - ${res.statusCode} (${duration}ms)`
    );
  });
  
  next();
};
